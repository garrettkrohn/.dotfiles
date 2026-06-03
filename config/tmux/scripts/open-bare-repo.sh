#!/usr/bin/env bash

# Script to open bare repos from treekanga.yml in a new tmux window

TREEKANGA_CONFIG="${HOME}/dotfiles/config/treekanga.yml"

# Check if config exists
if [[ ! -f "$TREEKANGA_CONFIG" ]]; then
    echo "Error: treekanga.yml not found at $TREEKANGA_CONFIG"
    exit 1
fi

# Extract repo names and worktree directories from the YAML
# Format: "repo-name|worktreeTargetDir"
repos=$(awk '
    /^  [a-zA-Z0-9_-]+:$/ {
        repo = $1
        gsub(/:$/, "", repo)
    }
    /worktreeTargetDir:/ {
        gsub(/^[[:space:]]*worktreeTargetDir:[[:space:]]*/, "")
        gsub(/#.*$/, "")
        gsub(/[[:space:]]*$/, "")
        print repo "|" $0
    }
' "$TREEKANGA_CONFIG")

# Check if we found any repos
if [[ -z "$repos" ]]; then
    echo "Error: No repos with worktreeTargetDir found in config"
    exit 1
fi

# Present fzf menu with repo names
selected=$(echo "$repos" | awk -F'|' '{print $1 " -> " $2}' | fzf --prompt="Select bare repo: " --height=40% --reverse)

# Exit if nothing selected
if [[ -z "$selected" ]]; then
    exit 0
fi

# Extract the worktree directory from the selection
worktree_dir=$(echo "$selected" | awk '{print $NF}')

# Construct the bare repo path
bare_repo_path="${HOME}${worktree_dir}/.bare"

# Check if bare repo exists
if [[ ! -d "$bare_repo_path" ]]; then
    echo "Error: Bare repo not found at $bare_repo_path"
    exit 1
fi

# Extract short name from worktree directory for the session name
# e.g., /code/cal_work -> cal, /code/front_end_work -> front_end
short_name=$(basename "$worktree_dir" | sed 's/_work$//')
session_name="${short_name} - bare"

# Check if session already exists
if tmux has-session -t "$session_name" 2>/dev/null; then
    # Session exists, switch to it
    tmux switch-client -t "$session_name"
else
    # Session doesn't exist, create it and switch to it
    if [[ -n "$TMUX" ]]; then
        # Already in tmux, create detached and switch
        tmux new-session -d -s "$session_name" -c "$bare_repo_path"
        tmux switch-client -t "$session_name"
    else
        # Not in tmux, create and attach
        tmux new-session -s "$session_name" -c "$bare_repo_path"
    fi
fi
