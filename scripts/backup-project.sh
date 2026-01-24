#!/bin/bash

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: Not a git repository. Please run this script from a git project root."
  exit 1
fi

# Get project name
PROJECT_NAME=$(basename "$(pwd)")

# Create backup with timestamp
TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S")
BACKUP_NAME="PROJ_${PROJECT_NAME}_${TIMESTAMP}"

echo "Creating backup: ${BACKUP_NAME}.zip"

# Use git archive to create zip (automatically respects .gitignore)
if git archive -o "../${BACKUP_NAME}.zip" HEAD; then
  echo "✓ Backup complete: ../${BACKUP_NAME}.zip"
else
  echo "Error: Failed to create backup archive."
  exit 1
fi
