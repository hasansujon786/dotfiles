#!/usr/bin/env bash

# Usage:
#   ./wezrun.sh /path/to/project

dir="$1"

if [[ -z "$dir" ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Spawn a new tab in the given dir and capture its pane-id
pane_id=$(wezterm cli spawn --cwd "$dir")

echo "Spawned pane: $pane_id"

# Send text to that newly created pane
echo "nvim" | wezterm cli send-text --pane-id "$pane_id"
