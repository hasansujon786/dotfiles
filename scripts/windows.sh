#!/bin/bash
##!/bin/sh
# @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install git -y
choco install microsoft-windows-terminal -y       # --pre
choco install potplayer -y
choco install 7zip.install -y
choco install googlechrome -y

# choco install gimp -y
# choco install vlc -y
# choco install emacs -y
# New-Item -ItemType SymbolicLink -Path 'C:\Users\hasan\AppData\Local\Microsoft\Windows Terminal\settings.json' -Target C:\Users\hasan\dotfiles\windows-terminal\settings.json

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
