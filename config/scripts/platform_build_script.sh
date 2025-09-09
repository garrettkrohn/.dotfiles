tmux kill-session -t local
tmux new -d -s local -n backend
tmux send-keys -t local:backend 'beb -d -s -c' Enter
tmux new-window -t local -n frontend
tmux send-keys -t local:frontend 'sleep 100 && feb' Enter
tmux new-window -t local -n bootstrap
tmux send-keys -t local:bootstrap 'sleep 100 && boot -r' Enter
