#!/bin/bash

# @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# https://developer.android.com/studio#downloads
# https://dl.google.com/android/repository/commandlinetools-win-8092744_latest.zip
# sdkmanager.bat "platforms;android-29" "platform-tools" "build-tools;28.0.3"

# A utility that manages a Registry key that allows Windows to remap one key to any other key.
# scoop install sharpkeys

# FIXME: riot
# choco install gimp -y
# choco install vlc -y
# choco install emacs -y

# choco install qbittorrent -y
# winget install eza-community.eza
# choco install -y microsoft-openjdk17
# winget install aristocratos.btop4win
# winget install GNU.Emacs
# scoop install abdownloadmanager obsidian

winget install -e PDFgear
scoop install brave qbittorrent localsend

scoop install extras/insomnia extras/telegram
scoop bucket add charm https://github.com/charmbracelet/scoop-bucket.git
scoop install crush

scoop bucket add github-gh https://github.com/cli/scoop-gh.git
scoop install gh

# Potplayer
scoop install potplayer
# fix:
# reg.exe import "C:\\Users\\$USERNAME\\dotfiles\\scripts\\PotPlayerMini64.reg"
