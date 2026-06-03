#!/usr/bin/env bash

set -e

# Get current branch
current_branch=$(git branch --show-current)

# Allow optional argument for release branch name, otherwise auto-generate
if [ -n "$1" ]; then
    release_branch="$1"
else
    # Remove feature/ prefix and replace with release/
    release_branch="${current_branch#feature/}"
    release_branch="release/${release_branch}"
fi

# Find merge-base between current branch and master
echo "Finding merge-base between $current_branch and master..."
merge_base=$(git merge-base "$current_branch" master)

if [ -z "$merge_base" ]; then
    echo "Error: Could not find merge-base"
    exit 1
fi

echo "Merge-base: $merge_base"
echo "Creating branch $release_branch from merge-base..."

# Create release branch from merge-base
git checkout -b "$release_branch" "$merge_base"

echo "Pushing $release_branch to origin..."
git push -u origin "$release_branch"

echo "Switching back to $current_branch..."
git checkout "$current_branch"

echo ""
echo "✓ Created and pushed $release_branch from $merge_base"
echo "✓ Back on $current_branch"

# Run tk add command
/Users/gkrohn/code/treekanga_work/v2/treekanga add "$release_branch" -t x
