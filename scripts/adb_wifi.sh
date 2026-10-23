#!/bin/bash

set -e

adb start-server

# Requires a connected and authorized device
devices=$(adb devices | awk 'NR > 1 && $2 == "device" { print $1 }')
count=$(printf '%s\n' "$devices" | grep -c . || true)

if [ "$count" -eq 0 ]; then
  echo "No authorized ADB device found."
  echo "Connect your phone via USB or use Wireless debugging."
  exit 1
fi

if [ -n "$ANDROID_SERIAL" ]; then
  serial="$ANDROID_SERIAL"
elif [ "$count" -eq 1 ]; then
  serial="$devices"
else
  echo "More than one device connected:"
  i=1
  while IFS= read -r d; do
    echo "  $i) $d"
    i=$((i + 1))
  done <<<"$devices"
  printf 'Select device [1-%s]: ' "$count"
  read -r choice

  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "$count" ]; then
    echo "Invalid selection."
    exit 1
  fi

  serial=$(printf '%s\n' "$devices" | sed -n "${choice}p")
fi

adb -s "$serial" tcpip 5555
sleep 3

output=$(adb -s "$serial" shell ip -4 addr show wlan0)
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
