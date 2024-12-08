#!/bin/bash

# @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# https://developer.android.com/studio#downloads
# https://dl.google.com/android/repository/commandlinetools-win-8092744_latest.zip
# sdkmanager.bat "platforms;android-29" "platform-tools" "build-tools;28.0.3"

# choco install gimp -y
# choco install vlc -y
# choco install emacs -y

# choco install qbittorrent -y
# winget install eza-community.eza
choco install -y microsoft-openjdk17
winget install aristocratos.btop4win
winget install GNU.Emacs
