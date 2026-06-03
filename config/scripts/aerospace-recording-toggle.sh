#!/bin/bash

# Follow symlink to actual config file
CONFIG_LINK="$HOME/.config/aerospace/aerospace.toml"
CONFIG_FILE="$(readlink -f "$CONFIG_LINK" 2>/dev/null || readlink "$CONFIG_LINK" 2>/dev/null || echo "$CONFIG_LINK")"

RECORDING_GAP=645
NORMAL_GAP=2

# Check current state by looking at outer.right value
current_gap=$(grep "^outer.right" "$CONFIG_FILE" | grep -o '[0-9]\+' | head -1)

if [ "$current_gap" = "$NORMAL_GAP" ]; then
    # Switch to recording mode
    sed -i '' "s/^outer.right =      $NORMAL_GAP$/outer.right =      $RECORDING_GAP/" "$CONFIG_FILE"
    echo "Recording mode ON (outer.right = $RECORDING_GAP)"
else
    # Switch back to normal mode
    sed -i '' "s/^outer.right =      $RECORDING_GAP$/outer.right =      $NORMAL_GAP/" "$CONFIG_FILE"
    echo "Recording mode OFF (outer.right = $NORMAL_GAP)"
fi

# Reload AeroSpace config
aerospace reload-config
