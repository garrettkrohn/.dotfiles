#!/bin/bash
# Initialize checkout variable
checkout=false
run_build=false

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "No PR Number provided"
    exit 1
fi

# Store the first argument as the pr_number variable
pr_number=$1

# Check if pr_number is an integer
if ! [[ "$pr_number" =~ ^[0-9]+$ ]]; then
    echo "Invalid PR Number: $pr_number is not an integer"
    exit 1
fi

# Print the pr_number variable to verify the result
echo "PR Number: $pr_number"

# Remove the first argument (pr_number) from the arguments
shift

# Parse flags
while getopts "cx" opt; do
    case $opt in
    c)
        checkout=true
        ;;
    x)
        run_build=true
        ;;
    *)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done

# Change directory
# cd ~/code/platform_work/review/

# Conditionally checkout branch
if [ "$checkout" = true ]; then
    remote_url=$(git remote get-url origin 2>/dev/null)
    if [[ "$remote_url" =~ bitbucket\.org[:/]([^/]+)/([^/.]+) ]]; then
        workspace="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    else
        echo "Could not parse Bitbucket workspace/repo from remote: $remote_url" >&2
        exit 1
    fi

    api_response=$(curl -s \
        -H "Authorization: Bearer ${BITBUCKET_TOKEN}" \
        "https://api.bitbucket.org/2.0/repositories/${workspace}/${repo}/pullrequests/${pr_number}")

    if [ -z "$api_response" ]; then
        echo "Empty response from Bitbucket API (check BITBUCKET_USER and BITBUCKET_APP_PASSWORD)" >&2
        exit 1
    fi

    branch=$(echo "$api_response" \
        | python3 -c "import sys,json; print(json.load(sys.stdin)['source']['branch']['name'])" 2>/dev/null)

    if [ -z "$branch" ]; then
        echo "Could not parse branch from API response:" >&2
        echo "$api_response" >&2
        exit 1
    fi

    if [ -z "$branch" ]; then
        echo "Could not determine branch for PR #$pr_number" >&2
        exit 1
    fi

    git fetch origin "$branch"
    git checkout "$branch"
    echo "Checked out branch: $branch"
fi

# Conditionally run build script
if [ "$run_build" = true ]; then
    review_platform_build_script.sh
    echo "running build on local session"
fi

# Open PR in a new tmux session named {repo}-pr#{number}
repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
session_name="${repo_name}-pr#${pr_number}"
work_dir="$(pwd)"

if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux switch-client -t "$session_name"
else
    tmux new-session -d -s "$session_name" -c "$work_dir"
    tmux send-keys -t "$session_name" "nvim -c ':Octo pr edit $pr_number'" Enter
    tmux switch-client -t "$session_name"
fi
