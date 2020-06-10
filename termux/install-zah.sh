#!/bin/bash
termux-setup-storage
apt update && apt upgrade
sh -c "$(curl -fsSL https://github.com/Cabbagec/termux-ohmyzsh/raw/master/install.sh)"

