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
    gh pr checkout $pr_number
    echo "checked out branch from pr"
fi

# Conditionally run build script
if [ "$run_build" = true ]; then
    review_platform_build_script.sh
    echo "running build on local session"
fi

# Open pr in Octo
nvim -c ":Octo pr edit $pr_number"
