# Completions for sqlite-docker-backup.
# Install as ~/.config/fish/completions/sqlite-docker-backup.fish
# The filename must match the command name exactly (minus the .fish suffix).

# Pull the volume out of the command line already typed, so -d can list the
# DB files that actually exist in it.
function __sqlite_docker_backup_volume
    set -l tok (commandline -opc)
    for i in (seq (count $tok))
        switch $tok[$i]
            case -v --volume
                if test (count $tok) -gt $i
                    echo $tok[(math $i + 1)]
                end
                return
            case '--volume=*'
                string replace -- '--volume=' '' $tok[$i]
                return
        end
    end
end

function __sqlite_docker_backup_dbs
    set -l vol (__sqlite_docker_backup_volume)
    test -n "$vol"; or return
    set -l image (set -q SQLITE_IMAGE; and echo $SQLITE_IMAGE; or echo alpine:3.20)
    # Only if the image is already local — a completion must never trigger a pull.
    docker image inspect $image >/dev/null 2>&1; or return
    docker run --rm -v $vol:/data:ro --entrypoint find $image \
        /data -maxdepth 4 -type f \
        \( -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' \) 2>/dev/null \
        | string replace -r '^/data/' ''
end

complete -c sqlite-docker-backup -f

# -x (= -r -f) on each option: the argument is required, and it is not a host
# path, so host files must not be offered alongside the real candidates.
complete -c sqlite-docker-backup -s v -l volume -x -d 'Docker volume' \
    -a "(docker volume ls -q 2>/dev/null)"
complete -c sqlite-docker-backup -s d -l db -x -d 'DB path inside the volume' \
    -a "(__sqlite_docker_backup_dbs)"
complete -c sqlite-docker-backup -s o -l out -x -d 'Host output directory' \
    -a "(__fish_complete_directories)"
complete -c sqlite-docker-backup -s n -l name -x -d 'Base name for backup files'
complete -c sqlite-docker-backup -s k -l keep -x -d 'Keep only the N newest backups' \
    -a '3 7 14 30'
complete -c sqlite-docker-backup -s z -l gzip -d 'gzip the result'
complete -c sqlite-docker-backup -s h -l help -d 'Show help'
