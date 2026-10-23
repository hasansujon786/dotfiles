#!/bin/bash

set -e

adb start-server

# Requires a connected and authorized device
if ! adb get-state >/dev/null 2>&1; then
  echo "No authorized ADB device found."
  echo "Connect your phone via USB or use Wireless debugging."
  exit 1
fi

adb tcpip 5555
sleep 3

output=$(adb shell ip -4 addr show wlan0)
echo "$output"
echo "___________________________________________________________"

ip=$(echo "$output" | awk '/inet / {
    split($2, addr, "/")
    if (addr[1] !~ /^127\./) {
        print addr[1]
        exit
    }
}')

if [ -z "$ip" ]; then
  echo "Could not find the phone's Wi-Fi IPv4 address."
  exit 1
fi

echo "Connecting to $ip:5555"
adb connect "$ip:5555"

adb devices
