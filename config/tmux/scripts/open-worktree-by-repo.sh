#!/usr/bin/env zsh

# Source environment to get access to fzf and tkc
source ~/.zshrc

# Path to treekanga config
config_file="${HOME}/dotfiles/config/treekanga.yml"

# Parse worktreeTargetDir from treekanga.yml and append /.bare
repos=$(grep 'worktreeTargetDir:' "$config_file" | \
  awk '{print $2}' | \
  sed 's|^|~|' | \
  sed 's|$|/.bare|')

selected=$(echo "$repos" | fzf --reverse --border --prompt='Select bare repo: ')

if [ -n "$selected" ]; then
  # Expand tilde
  selected="${selected/#\~/$HOME}"
  cd "$selected" && exec tkc
fi
