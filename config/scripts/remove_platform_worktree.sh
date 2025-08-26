#!/bin/bash

# Initialize variables
folder_name=""
force=false

# Function to display usage
usage() {
    echo "Usage: $0 -n folder_name [-f]"
    echo "  -n folder_name   Specify the folder name"
    echo "  -f               Set the force flag"
    exit 1
}

# Parse command line arguments
while getopts ":n:f" opt; do
    case ${opt} in
        n )
            folder_name=$OPTARG
            ;;
        f )
            force=true
            ;;
        \? )
            usage
            ;;
        : )
            echo "Option -$OPTARG requires an argument."
            usage
            ;;
    esac
done

# Check if folder_name is set
if [ -z "$folder_name" ]; then
    echo "Error: folder_name is required."
    usage
fi

# Output the results
echo "Folder name: $folder_name"
echo "Force flag: $force"

cd ~/code/platform_work/platform_bare/

if force do
    git worktree remove -f $"folder_name"  
else
