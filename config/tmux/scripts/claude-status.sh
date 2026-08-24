#!/bin/bash

# claude-status.sh - Display Claude Code session status for tmux sessions
# Shows session names with their Claude status emojis

SESSIONS_DIR="$HOME/.claude/sessions"

# Status emoji mapping
STATUS_IDLE="💤"
STATUS_BUSY="⚙️"
STATUS_WAITING="⏸️"

# Get all tmux sessions with their working directories
get_tmux_sessions() {
    tmux list-sessions -F "#{session_name}:#{pane_current_path}" 2>/dev/null
}

# Get Claude session status for a directory
get_claude_status() {
    local dir="$1"

    # Check if sessions directory exists
    if [[ ! -d "$SESSIONS_DIR" ]]; then
        echo ""
        return
    fi

    # Normalize directory path
    local normalized_dir
    normalized_dir=$(cd "$dir" 2>/dev/null && pwd -P)

    if [[ -z "$normalized_dir" ]]; then
        echo ""
        return
    fi

    # Check all session files
    for session_file in "$SESSIONS_DIR"/*.json; do
        if [[ ! -f "$session_file" ]]; then
            continue
        fi

        # Extract cwd and status using jq (faster) or grep/sed fallback
        if command -v jq &> /dev/null; then
            local session_cwd
            local session_status
            session_cwd=$(jq -r '.cwd // empty' "$session_file" 2>/dev/null)
            session_status=$(jq -r '.status // empty' "$session_file" 2>/dev/null)

            if [[ "$session_cwd" == "$normalized_dir" ]]; then
                case "$session_status" in
                    idle)    echo "$STATUS_IDLE" ;;
                    busy)    echo "$STATUS_BUSY" ;;
                    waiting) echo "$STATUS_WAITING" ;;
                    *)       echo "" ;;
                esac
                return
            fi
        else
            # Fallback to grep/sed if jq is not available
            local session_cwd
            local session_status
            session_cwd=$(grep -o '"cwd":"[^"]*"' "$session_file" | sed 's/"cwd":"\(.*\)"/\1/')
            session_status=$(grep -o '"status":"[^"]*"' "$session_file" | sed 's/"status":"\(.*\)"/\1/')

            if [[ "$session_cwd" == "$normalized_dir" ]]; then
                case "$session_status" in
                    idle)    echo "$STATUS_IDLE" ;;
                    busy)    echo "$STATUS_BUSY" ;;
                    waiting) echo "$STATUS_WAITING" ;;
                    *)       echo "" ;;
                esac
                return
            fi
        fi
    done

    echo ""
}

# Format session with Claude status
format_session() {
    local session_name="$1"
    local session_path="$2"
    local claude_status

    claude_status=$(get_claude_status "$session_path")

    # Only show if status is waiting (needs approval)
    if [[ "$claude_status" == "$STATUS_WAITING" ]]; then
        echo "${claude_status}${session_name}"
    fi
}

# Main execution
main() {
    local output=""
    local session_count=0

    # Get current session name
    local current_session
    current_session=$(tmux display-message -p '#S' 2>/dev/null)

    # Process all sessions
    while IFS=: read -r session_name session_path; do
        local formatted
        formatted=$(format_session "$session_name" "$session_path")

        if [[ -n "$formatted" ]]; then
            if [[ $session_count -gt 0 ]]; then
                output="${output} | "
            fi

            # Highlight current session
            if [[ "$session_name" == "$current_session" ]]; then
                output="${output}#[fg=magenta,bold]${formatted}#[default]"
            else
                output="${output}#[fg=white]${formatted}#[default]"
            fi

            ((session_count++))
        fi
    done < <(get_tmux_sessions)

    # Output result (empty if no sessions with Claude)
    if [[ $session_count -gt 0 ]]; then
        echo "$output"
    fi
}

main
