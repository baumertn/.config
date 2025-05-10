function start_tmux
    if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            set session_name (basename "$PWD")
            tmux -2 attach -t $session_name; or tmux -2 new-session -s $session_name
        end
    end
end
