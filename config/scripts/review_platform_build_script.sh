#!/bin/bash
# Get the current session name
current_session=$(tmux display -p '#{session_name}')

# Define the working directory
WORK_DIR="/Users/gkrohn/code/platform_work/review"

# Only kill the 'local' session if we're not currently in it
if [ "$current_session" != "local" ]; then
    tmux kill-session -t local 2>/dev/null
fi

# Create the new local session and windows with the specified directory
tmux new -d -s local -n backend -c "$WORK_DIR"
tmux send-keys -t local:backend 'beb -d -s -c' Enter

tmux new-window -t local -n frontend -c "$WORK_DIR"
tmux send-keys -t local:frontend 'sleep 150 && feb' Enter

tmux new-window -t local -n client_ui -c "$WORK_DIR"
tmux send-keys -t local:client_ui 'sleep 150 && feb -u' Enter

tmux new-window -t local -n bootstrap -c "$WORK_DIR"
tmux send-keys -t local:bootstrap 'sleep 150 && boot -r && say "build is complete"' Enter
