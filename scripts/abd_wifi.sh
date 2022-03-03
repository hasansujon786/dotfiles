#!/bin/sh

adb devices
adb kill-server
adb start-server
adb tcpip 5555
sleep 1
adb shell ip addr show wlan0
