tmux kill-session -t local
tmux new -d -s local
tmux send-keys -t local 'beb -d -s -c' Enter
tmux new-window -t local
tmux send-keys -t local:2 'sleep 80 && feb' Enter
tmux new-window -t local
tmux send-keys -t local:3 'sleep 80 && boot -r' Enter
