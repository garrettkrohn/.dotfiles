#!/bin/bash

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

cd ~/code/platform_work/review/

# open pr in Octo
nvim -c ":Octo pr edit $pr_number"
