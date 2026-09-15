function gcb --description 'Bare clone with full fetch refspec for worktree hub usage'
    set -l url $argv[1]
    set -l dest $argv[2]
    if test -z "$url"
        echo "usage: git-clone-bare <url> [dest|.git]"
        return 1
    end
    if test -z "$dest"
        set dest .git
    end
    git clone --bare "$url" "$dest"
    or return $status
    git -C "$dest" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    git -C "$dest" fetch origin
end
