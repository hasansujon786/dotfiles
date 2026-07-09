#!/usr/bin/env bash

backup_and_link() {
  local source="$1"
  local target="$2"

  if [ ! -e "$source" ]; then
    echo " Source does not exist: $source"
    return 1
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    local backup
    backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$target" "$backup"
    echo " Backed up '$target' -> '$backup'"
  fi

  ln -s "$source" "$target"
  echo " Linked '$target' -> '$source'"
}

backup_and_link ~/dotfiles/nvim ~/.config/nvim
backup_and_link ~/dotfiles/gui/wezterm ~/.config/wezterm
