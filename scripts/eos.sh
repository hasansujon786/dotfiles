#!/bin/bash
##!/bin/sh
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:philip.scott/pantheon-tweaks
sudo apt install -y pantheon-tweaks
# sudo apt install gnome-tweaks -y

sudo apt install apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt install brave-browser

sudo apt install snapd
sudo snap install alacritty --classic

sudo add-apt-repository -y multiverse
sudo apt install -y ubuntu-restricted-extras

sudo apt-get install -y gnome-disk-utility
sudo apt-get install -y gnome-system-monitor

wget https://github.com/subhra74/xdm/releases/download/7.2.11/xdm-setup-7.2.11.tar.xz
tar -xvf xdm-setup-7.2.11.tar.xz
sudo sh install.sh
