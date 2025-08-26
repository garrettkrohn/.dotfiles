#!/bin/bash

# Initialize variables
branch_name=""
folder_name=""

# Function to display usage
usage() {
    echo "Error: Both branch_name and folder_name must be set."
    echo "Usage: $0 -b branch_name -n folder_name"
    exit 1  
}

# Parse command line arguments
while getopts ":b:n:" opt; do
    case ${opt} in
        b )
            branch_name=$OPTARG
            ;;
        n )
            folder_name=$OPTARG
            ;;
        \? )
            usage
            exit 1
            ;;
    esac
done

# Check if both variables are set
if [ -z "$branch_name" ] || [ -z "$folder_name" ]; then
    echo "please input branch_name and folder_name"
    exit 1  
fi

# Move to bare repo
cd ~/code/platform_work/platform_bare || { echo "Failed to change directory to ~/code/platform_work/platform_bare"; }
echo "moving to bare repo"


# Create new worktree
git worktree add -b "$branch_name" ../"$folder_name" || { echo "Failed to create new worktree"; }

# Change to worktree
cd ../"$folder_name" || { echo "Failed to change directory to ../$folder_name"; }

echo "Successfully changed to worktree directory: ../$folder_name"

