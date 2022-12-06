#!/bin/sh

# @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install instanteyedropper -y
choco install potplayer -y
choco install ntop.portable -y
choco install googlechrome -y
choco install sharpkeys -y

# https://developer.android.com/studio#downloads
# https://dl.google.com/android/repository/commandlinetools-win-8092744_latest.zip
# sdkmanager.bat "platforms;android-29" "platform-tools" "build-tools;28.0.3"

# choco install gimp -y
# choco install vlc -y
# choco install emacs -y

# choco install qbittorrent -y
# choco install etcher -y
# choco install javaruntime -y
# choco install adobereader -y
# choco install pdfcreator -y
# choco install markdownpad2 -y
# choco install conemu -y
# choco install mobaxterm -y
# choco install InkScape -y
# choco install etcher -y
# choco install slack -y
# choco install Xming -y
