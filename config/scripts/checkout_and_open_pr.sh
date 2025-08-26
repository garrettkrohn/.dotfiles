#!/bin/bash

# Initialize checkout variable
checkout=false

# Parse flags
while getopts "c" opt; do
  case $opt in
    c)
      checkout=true
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Remove the processed options from the arguments
shift $((OPTIND-1))

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

# Change directory
# cd ~/code/platform_work/review/

# Conditionally checkout branch
if [ "$checkout" = true ]; then
  gh pr checkout $pr_number
fi

# Open pr in Octo
nvim -c ":Octo pr edit $pr_number"

