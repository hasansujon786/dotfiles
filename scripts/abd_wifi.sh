#!/bin/sh

adb kill-server
adb start-server
adb tcpip 5555
sleep 1
# adb shell ip addr show wlan0
output=$(adb shell ip addr show wlan0)
echo "$output"
echo "___________________________________________________________"
echo "$output" | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' | head -n 1 | xargs adb connect
adb devices
# adb -s f8a8aa489804 tcpip 5555
# adb -s f8a8aa489804 connect 192.168.0.100
