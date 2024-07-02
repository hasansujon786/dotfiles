#!/bin/bash
set -e
result=$(curl -F"file=@$1" -Fexpires=72 https://0x0.st)
echo "${result}" | clip
