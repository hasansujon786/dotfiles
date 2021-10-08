#!/bin/bash
##!/bin/sh
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:philip.scott/pantheon-tweaks
sudo apt install -y pantheon-tweaks
# sudo apt install gnome-tweaks -y

sudo add-apt-repository -y multiverse
sudo apt install -y ubuntu-restricted-extras

sudo apt-get install -y gnome-disk-utility
sudo apt-get install -y gnome-system-monitor

sudo apt install snapd
sudo snap install alacritty --classic

