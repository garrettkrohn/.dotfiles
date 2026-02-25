#!/usr/bin/env bash

WALLPAPER_DIR="${HOME}/wallpapers"
CACHE_FILE="${HOME}/.cache/wezterm_wallpaper"

mkdir -p "$(dirname "$CACHE_FILE")"

if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed"
    exit 1
fi

if command -v chafa &> /dev/null; then
    PREVIEW_CMD="chafa -f symbols --symbols all {}"
elif command -v viu &> /dev/null; then
    PREVIEW_CMD="viu {}"
elif command -v catimg &> /dev/null; then
    PREVIEW_CMD="catimg {}"
else
    PREVIEW_CMD="echo 'Install chafa, viu, or catimg for image preview\n\nFile: {}'"
fi

selected=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    | fzf --preview="$PREVIEW_CMD" \
          --preview-window=right:60% \
          --height=100% \
          --border \
          --prompt="Select wallpaper: " \
          --header="Press ENTER to select, ESC to cancel" \
          --cycle)

if [ -n "$selected" ]; then
    echo "$selected" > "$CACHE_FILE"
    echo "Wallpaper set to: $(basename "$selected")"
    
    if [ -n "$WEZTERM_PANE" ]; then
        printf "\033]1337;SetUserVar=%s=%s\007" "WALLPAPER_CHANGE" "$(echo -n "reload" | base64)"
        sleep 0.1
        wezterm cli set-user-var WALLPAPER_CHANGE reload 2>/dev/null || true
    fi
    
    echo "Reloading WezTerm configuration..."
    wezterm cli reload-configuration 2>/dev/null || echo "Note: Run 'Cmd+R' to reload WezTerm if wallpaper didn't change"
else
    echo "No wallpaper selected"
    exit 1
fi
