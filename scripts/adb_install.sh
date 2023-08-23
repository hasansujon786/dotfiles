#!/bin/sh
apk=${1}

echo "Installing..."
device_id=$(~/dotfiles/scripts/ld.sh)

echo "$apk in $device_id"
adb -s $device_id install -t -r $apk
