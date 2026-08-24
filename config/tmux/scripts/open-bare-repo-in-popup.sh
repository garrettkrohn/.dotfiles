#!/bin/bash

# Get the list of bare repos from treekanga config
CONFIG_FILE="$HOME/.config/treekanga/treekanga.yml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: treekanga config not found at $CONFIG_FILE"
    exit 1
fi

# Extract repo names and their bare repo locations from the config
repos=$(awk '
    /^  [a-zA-Z0-9_-]+:$/ {
        repo = substr($1, 1, length($1)-1)
        bare_name = ".bare"
    }
    /bareRepoName:/ {
        bare_name = $2
    }
    /worktreeTargetDir:/ {
        dir = $2
        # Expand ~ to $HOME
        gsub(/~/, ENVIRON["HOME"], dir)
        # If path starts with / but not with HOME, prepend HOME
        if (dir ~ /^\/[^\/]/ && dir !~ "^" ENVIRON["HOME"]) {
            dir = ENVIRON["HOME"] dir
        }
        bare_path = dir "/" bare_name
        print repo "\t" bare_path
    }
' "$CONFIG_FILE")

# Use fzf to select a bare repo
selected=$(echo "$repos" | fzf \
    --prompt="Select bare repo: " \
    --height=100% \
    --border \
    --with-nth=1 \
    --delimiter='\t' \
    --preview 'ls -la {2}' \
    --preview-window=right:50%)

if [ -z "$selected" ]; then
    exit 0
fi

# Extract the path (second column)
bare_path=$(echo "$selected" | cut -f2)

# Change to the selected directory and open a shell
cd "$bare_path" || exit 1
exec $SHELL
