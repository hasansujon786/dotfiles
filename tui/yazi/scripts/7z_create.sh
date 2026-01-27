#!/bin/bash
#
# Yazi Archive Create script
#
# Use 7zip to create zip archive

# Get the filename without extension
BASENAME=$(basename "$1")
FILENAME="${BASENAME%.*}"

# Create zip in the same directory
7z a -tzip "$FILENAME" "$1"

sleep 2
