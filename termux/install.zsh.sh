#!/bin/bash
sh -c "$(curl -fsSL https://github.com/hasansujon786/termux-ohmyzsh/raw/master/install.sh)"
printf 'source ~/dotfiles/bash/autocomplete.zsh' >> ~/.zshrc
rm -Rf /data/data/com.termux/files/usr/etc/motd
echo 'Welcome to Termux!' >> /data/data/com.termux/files/usr/etc/motd
termux-setup-storage
apt upgrade && apt update 
# pkg update
pkg install termux-api
