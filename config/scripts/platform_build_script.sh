#!/bin/bash

# Initialize flags
run_scan=false
run_global=false

## Parse the arguments
for arg in "$@"; do
    case $arg in
    -s)
        run_scan=true
        ;;
    -g)
        run_global=true
        ;;
    -h)
        echo "Usage: $0 [-s] [-g]"
        echo "  -s    Add scan window"
        echo "  -g    Add g window"
        exit 0
        ;;
    *)
        echo "Invalid option: $arg" >&2
        exit 1
        ;;
    esac
done

# Get the current session name
current_session=$(tmux display -p '#{session_name}')

# Only kill the 'local' session if we're not currently in it
if [ "$current_session" != "local" ]; then
    tmux kill-session -t local 2>/dev/null
fi

# Create the new local session and windows
tmux new -d -s local -n backend
tmux send-keys -t local:backend 'beb -d -s -c' Enter

tmux new-window -t local -n frontend
tmux send-keys -t local:frontend 'sleep 150 && feb' Enter

tmux new-window -t local -n client_ui
tmux send-keys -t local:client_ui 'sleep 150 && feb -u' Enter

tmux new-window -t local -n bootstrap
tmux send-keys -t local:bootstrap 'sleep 150 && boot -r' Enter

# Add scan window if -s flag was provided
if [ "$run_scan" = true ]; then
    tmux new-window -t local -n scan
    tmux send-keys -t local:scan 'sleep 150 && rs' Enter
fi

# Add global window if -g flag was provided
if [ "$run_global" = true ]; then
    tmux new-window -t local -n global
    tmux send-keys -t local:global 'sleep 150 && rg' Enter
fi
