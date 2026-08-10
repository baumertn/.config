# Autoloaded function version.
# Install as ~/.config/fish/functions/sqlite-docker-backup.fish — the filename must
# match the function name, or fish will never autoload it.
#
# Differences from the standalone script:
#   * `exit` becomes `return` — inside a function, `exit` kills the whole shell.
#   * helpers are namespaced `__sqlite_docker_backup_*` so they don't collide with
#     anything else once they get defined globally on first call.
#   * help text is inline instead of sed-ing the source file, because
#     `status filename` in an autoloaded function points at the autoload file
#     and breaks the moment the comment block moves.

function __sqlite_docker_backup_log
    echo "["(date +%H:%M:%S)"] $argv"
end

function __sqlite_docker_backup_usage
    printf '%s\n' \
        'Back up a live SQLite database from a Docker volume onto the host.' \
        '' \
        'Usage: sqlite-docker-backup -v <volume> -d <db-path-inside-volume> [options]' \
        '' \
        '  -v/--volume   Docker volume name                    (required)' \
        '  -d/--db       DB path relative to the volume root   (required)' \
        '  -o/--out      Host output directory                 (default: ./backups)' \
        '  -n/--name     Base name for backup files            (default: DB filename stem)' \
        '  -k/--keep     Keep only the N newest backups        (default: 0 = keep all)' \
        '  -z/--gzip     gzip the result' \
        '  -h/--help     This help' \
        '' \
        'Env: SQLITE_IMAGE overrides the helper image (default alpine:3.20)' \
        'Returns: 0 ok, 1 usage/precondition, 2 backup failed, 3 verification failed'
end

function sqlite-docker-backup -d 'Back up a SQLite DB from a Docker volume to the host'
    # Local shadow of the error helper: it must `return` from *this* function,
    # so it cannot be factored out into a helper.
    argparse -n sqlite-docker-backup 'v/volume=' 'd/db=' 'o/out=' 'n/name=' 'k/keep=' z/gzip h/help -- $argv
    or return 1

    if set -q _flag_help
        __sqlite_docker_backup_usage
        return 0
    end

    if not set -q _flag_volume
        echo 'error: missing -v <volume>' >&2
        return 1
    end
    if not set -q _flag_db
        echo 'error: missing -d <db path inside volume>' >&2
        return 1
    end

    set -l volume $_flag_volume
    set -l db_rel $_flag_db
    set -l out_dir (set -q _flag_out; and echo $_flag_out; or echo ./backups)
    set -l keep (set -q _flag_keep; and echo $_flag_keep; or echo 0)
    set -l image (set -q SQLITE_IMAGE; and echo $SQLITE_IMAGE; or echo alpine:3.20)

    if string match -qr '^/' -- $db_rel
        echo 'error: -d must be relative to the volume root (no leading /)' >&2
        return 1
    end
    if not string match -qr '^[0-9]+$' -- $keep
        echo 'error: -k must be a non-negative integer' >&2
        return 1
    end
    if not command -q docker
        echo 'error: docker not found in PATH' >&2
        return 1
    end
    if not docker volume inspect $volume >/dev/null 2>&1
        echo "error: no such volume: $volume" >&2
        return 1
    end

    set -l base_name
    if set -q _flag_name
        set base_name $_flag_name
    else
        set base_name (string replace -r '\.[^.]*$' '' (basename $db_rel))
    end

    if not mkdir -p $out_dir
        echo "error: cannot create $out_dir" >&2
        return 1
    end
    set -l out_abs (realpath $out_dir)
    set -l file "$base_name-"(date +%Y%m%d-%H%M%S)".sqlite"
    set -l out "$out_abs/$file"

    __sqlite_docker_backup_log "snapshotting volume $volume:/$db_rel"

    # /data = the volume, read-only: a snapshot must never mutate the live DB.
    # /out  = host output dir, writable: the snapshot lands there directly.
    # VACUUM INTO yields a consistent, compacted copy of a DB that is being
    # written to; the .backup fallback covers SQLite < 3.27.
    set -l inner '
set -e
apk add --no-cache sqlite >/dev/null 2>&1 || { echo "cannot install sqlite in this image" >&2; exit 2; }
[ -f "$DB" ] || { echo "$DB not found in volume" >&2; exit 2; }
if ! sqlite3 "file:$DB?mode=ro" ".timeout 30000" "VACUUM INTO \'$DEST\'" 2>/dev/null; then
  echo "VACUUM INTO unavailable, falling back to .backup" >&2
  rm -f "$DEST"
  sqlite3 "file:$DB?mode=ro" ".timeout 30000" ".backup \'$DEST\'"
fi
'

    if not docker run --rm \
            -v $volume:/data:ro \
            -v $out_abs:/out \
            -e DB="/data/$db_rel" \
            -e DEST="/out/$file" \
            --entrypoint sh \
            $image -c $inner
        rm -f $out
        echo 'error: snapshot failed' >&2
        return 2
    end

    # Written by root inside the container; hand it to the invoking user from a
    # container (root there) so no sudo is needed on the host.
    if not test -O $out
        docker run --rm -v $out_abs:/out --entrypoint chown $image \
            (id -u):(id -g) "/out/$file" 2>/dev/null; or true
    end

    if command -q sqlite3
        set -l res (sqlite3 $out 'PRAGMA integrity_check;' 2>&1)
        or begin
            echo "error: integrity_check errored: $res" >&2
            return 3
        end
        if test "$res" != ok
            echo "error: integrity_check failed: $res" >&2
            return 3
        end
        __sqlite_docker_backup_log 'integrity_check ok'
    else
        __sqlite_docker_backup_log 'host sqlite3 missing, skipping integrity_check'
    end

    if set -q _flag_gzip
        if not gzip -f $out
            echo 'error: gzip failed' >&2
            return 2
        end
        set out "$out.gz"
    end

    __sqlite_docker_backup_log "done: $out "(du -h $out | cut -f1)

    # Rotation: delete all but the N newest backups sharing this base name.
    if test $keep -gt 0
        set -l old (ls -1t $out_abs/$base_name-*.sqlite* 2>/dev/null | tail -n +(math $keep + 1))
        for f in $old
            rm -f -- $f
            __sqlite_docker_backup_log "pruned $f"
        end
    end
end
