#!/bin/bash

# setup ---------------------------------
# git clone https://github.com/RoryNesbitt/pvim
# git clone <YOURCONFIG> pvim/config
# PATH="$(pwd)/pvim:$PATH"
# ---------------------------------------

export CLR_RESET='\033[1;0m'
export STL_BOLD='\033[1;1m'
export CLR_RED='\033[0;31m'
export CLR_GREEN='\033[0;32m'
export CLR_BLUE='\033[0;34m'
msg() {
  printf "${CLR_BLUE}${STL_BOLD}::${CLR_RESET} ${STL_BOLD}%s${CLR_RESET}\n" "$1"
  shift
  for i in "$@"; do
    printf " ${CLR_BLUE}${STL_BOLD}|${CLR_RESET} ${STL_BOLD}%s${CLR_RESET}\n" "$i"
  done
}

os="windows"

util_makeSymlinkPath() {
  # $1 = actual path (from)
  # $2 = symlink path (to)
  if [[ "$os" == "windows" ]]; then
    powershell New-Item -ItemType SymbolicLink -Path "$2" -Target "$1"
  else
    ln -s "$1" "$2"
  fi
}

msg "setup pvim/config..."
rm -rf "$HOME/pvim/config"
util_makeSymlinkPath "$HOME/dotfiles/nvim" "$HOME/pvim/config"
cp -r "$HOME/dotfiles/nvim" "$HOME/pvim/config.bak"

msg "setup pvim/clutter/lazy..."
rm -rf "$HOME/pvim/clutter/lazy/"
mkdir -p "$HOME/pvim/clutter/lazy/lazy"
cp -r ~/AppData/Local/nvim-data/lazy ~/pvim/clutter/lazy/lazy

msg "setup pvim/clutter/mason..."
rm -rf "$HOME/pvim/clutter/mason"
cp -r ~/AppData/Local/nvim-data/mason ~/pvim/clutter/mason
