#!/bin/bash
termux-setup-storage
apt update && apt upgrade
sh -c "$(curl -fsSL https://github.com/Cabbagec/termux-ohmyzsh/raw/master/install.sh)"
printf 'source ~/dotfiles/bash/autocomplete.zsh' >> ~/.zshrc
rm -Rf /data/data/com.termux/files/usr/etc/motd
printf 'Welcome to Termux!' >> /data/data/com.termux/files/usr/etc/motd
