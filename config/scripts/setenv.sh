#!/usr/bin/env bash
# Interactive environment switcher with fzf

REPO_ENVS_DIR="$HOME/code/rx/repo-envs"

if [[ ! -d "$REPO_ENVS_DIR" ]]; then
  echo "❌ Environment directory not found: $REPO_ENVS_DIR" >&2
  exit 1
fi

# Get list of environments (exclude .private.env files)
envs=()
for env_file in "$REPO_ENVS_DIR"/*.env; do
  if [[ -f "$env_file" && ! "$env_file" =~ \.private\.env$ ]]; then
    env_name=$(basename "$env_file" .env)
    envs+=("$env_name")
  fi
done

if [[ ${#envs[@]} -eq 0 ]]; then
  echo "❌ No environments found in $REPO_ENVS_DIR" >&2
  exit 1
fi

# Use fzf to select environment
selected=$(printf '%s\n' "${envs[@]}" | fzf \
  --height=40% \
  --reverse \
  --border \
  --prompt="Select environment: " \
  --preview="echo '📍 Environment: {}'; echo ''; cat $REPO_ENVS_DIR/{}.env | grep -E '^export ' | sed 's/export //g' | sed 's/\"//g'" \
  --preview-window=right:60%:wrap \
  --header="↑↓: navigate | enter: select | esc: cancel")

if [[ -n "$selected" ]]; then
  # Output the environment name so it can be sourced
  echo "$selected"
else
  echo "" >&2
  exit 1
fi
