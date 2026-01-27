#!/bin/bash
#
# Yazi Archive Extract script
#
# Use 7zip for extractor

# Get the filename without extension
BASENAME=$(basename "$1")
FILENAME="${BASENAME%.*}"

if [ "$2" == "CWD" ]; then
  7z x "$1"
else
  7z x "$1" -o"${FILENAME}"
fi

sleep 2
