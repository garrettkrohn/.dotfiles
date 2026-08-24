# Tmux Scripts

## Claude Status Integration

### Overview
The `claude-status.sh` script displays Claude Code session status for all tmux sessions in a centered status line at the top of tmux.

### Status Indicators
- **💤** - Claude is idle (waiting for your input)
- **⚙️** - Claude is actively working on a task
- **⏸️** - Claude needs approval/permission to proceed

### Display Format
Shows session names with their status emojis, separated by `|`:
```
💤session1 | ⚙️session2 | ⏸️session3
```

The current session is highlighted in magenta/bold.

### How It Works
1. Reads Claude Code session files from `~/.claude/sessions/`
2. Matches tmux session working directories with Claude session directories
3. Displays only sessions that have active Claude sessions
4. Updates every 3 seconds (configured via `status-interval` in tmux.conf)

### Configuration
The script is called from `tmux.conf`:
```tmux
set -g status 2  # Enable two status lines
set -g status-format[1] '#[align=centre]#($HOME/dotfiles/config/tmux/scripts/claude-status.sh)'
```

### Requirements
- jq (optional, for faster JSON parsing - falls back to grep/sed if not available)
- Claude Code running in one or more tmux sessions

### Troubleshooting

**Status not showing:**
- Ensure Claude Code is running in a tmux session
- Check that `~/.claude/sessions/` exists and contains session files
- Verify the tmux session's working directory matches the Claude session's `cwd` field
- Reload tmux config: `<prefix> + R` or `tmux source-file ~/.config/tmux/tmux.conf`

**Performance concerns:**
- The script only runs every 3 seconds (configurable via `status-interval`)
- Uses jq for efficient JSON parsing when available
- Only shows sessions with active Claude sessions (not all sessions)
