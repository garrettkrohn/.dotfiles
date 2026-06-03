#!/bin/bash

# Get the current branch name
current_branch=$(git branch --show-current)

# Push the current branch to origin and set upstream
git push -u origin "$current_branch"
