#!/bin/bash
sh -c "$(curl -fsSL https://github.com/hasansujon786/termux-ohmyzsh/raw/master/install.sh)"
printf 'source ~/dotfiles/bash/autocomplete.zsh' >> ~/.zshrc
rm -Rf /data/data/com.termux/files/usr/etc/motd
echo 'Welcome to Termux!' >> /data/data/com.termux/files/usr/etc/motd
cp ~/dotfiles/termux/cascadia.ttf ~/.termux/font.ttf
