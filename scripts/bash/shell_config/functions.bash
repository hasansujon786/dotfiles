#!/bin/bash

# Colored output for readability
info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }

set_path() {
  # Safely check if argument is provided using ${1:-}
  if [ -z "${1:-}" ]; then
    error "Missing argument. Usage: update_path_var <path-to-add>"
    return 1
  fi

  local NEW_PATH="$(cygpath -w "$1")"
  local SCRIPT="$(cygpath -w "$HOME/dotfiles/scripts/set_path.ps1")"

  info "Updating PATH with: $NEW_PATH"

  powershell.exe -File "$SCRIPT" -newPath "$NEW_PATH"
  local status=$?

  if [ $status -ne 0 ]; then
    error "Failed to update PATH. PowerShell exited with status $status."
    return $status
  fi
}
set_var() {
  # Safely check if both arguments are provided
  if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
    error "Missing arguments. Usage: create_user_var <variable-name> <variable-value>"
    return 1
  fi

  local VAR_NAME="$1"
  local VAR_VALUE="$(cygpath -w "$2")"
  local SCRIPT="$(cygpath -w "$HOME/dotfiles/scripts/set_var.ps1")"

  info "Creating user environment variable: $VAR_NAME=$VAR_VALUE"

  powershell.exe -File "$SCRIPT" -varName "$VAR_NAME" -varValue "$VAR_VALUE"
  local status=$?

  if [ $status -ne 0 ]; then
    error "Failed to create environment variable. PowerShell exited with status $status."
    return $status
  fi
}

jump_to_git_root() {
  local _root_dir _pwd

  _root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ $_root_dir == "" ]]; then
    >&2 echo 'Not a Git repo!'
    return 0
  fi
  _pwd=$(pwd -W)
  if [[ $_pwd = "$_root_dir" ]]; then
    # Handle submodules:
    # If parent dir is also managed under Git then we are in a submodule.
    # If so, cd to nearest Git parent project.
    if ! _root_dir="$(git -C "$(dirname "$_pwd")" rev-parse --show-toplevel 2>/dev/null)"; then
      echo "Already at Git repo root."
      return 0
    fi
  fi
  # Make `cd -` work.
  OLDPWD=$_pwd
  echo "Git repo root: $_root_dir"
  cd "$_root_dir" || exit
}
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd" || exit
  rm -f -- "$tmp"
}
lfcd() {
  tmp="$(mktemp)"
  \lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    if [ -d "$dir" ]; then
      if [ "$dir" != "$(pwd)" ]; then
        cd "$dir" || exit
      fi
    fi
  fi
}
remove() {
  while true; do
    local count=$#
    if [[ $count = 0 ]]; then
      echo "rm: missing argument"
      return
    fi
    local item='item'
    [[ $count -gt 1 ]] && item="items"

    read -r -p "trash: Do you wish to remove ${count} ${item} (y/n)? " yn
    case $yn in
    # [Yy]* ) rm -rf $@; break;;
    [Yy]*)
      trash "$@"
      break
      ;;
    [Nn]*)
      echo "rm: Canceled"
      break
      ;;
    *) echo "rm: Please answer yes or no." ;;
    esac
  done
}

# Calculator
c() { echo "scale=5;$*" | bc -l; }

redrive() {
  curl --silent -I -L "$@" | grep -i location
}

qrcode() {
  qrencode -t ANSI256 "$*"
  # echo "$@" | curl -F-=\<- qrenco.de
}
logv() {
  if [ -z "$1" ]; then
    echo "Usage: logv <filename>"
    return 1
  fi

  local file="$1"

  if [ ! -f "$file" ]; then
    echo "File '$file' does not exist."
    return 1
  fi

  tail -f "$file" | bat --paging=never --language log
}
open() {
  if [ $# -eq 0 ]; then
    explorer
    return 0
  fi

  for item in "$@"; do
    # if [ ! -e "$item" ]; then
    #   echo "❌ '$item' not found"
    #   continue
    # fi
    start "$item"
  done
}

find_alias() {
  local selected
  selected=$(alias | sed -E "s/^alias ([^=]+)='(.*)'$/\1  =  \2/" | fzf --border-label="Run alias")

  if [[ -z "$selected" ]]; then
    return
  fi

  local command
  command=$(echo "$selected" | cut -d'=' -f2 | xargs)
  command="$command "

  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$command${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$((READLINE_POINT + ${#command}))
}

alias ghnpush="gh repo create --public --source=. --remote=origin --push"
alias gsh='gh auth switch -u hasanmahmud7152'
alias gsn='gh auth switch -u hasansujon786'

GREEN="\e[32m"
RESET="\e[0m"
# Function to get the active GitHub account
function gh_active_user() {
  local user
  user=$(gh auth status 2>/dev/null |
    awk '/Logged in to github.com account/ {user=$7} /Active account: true/ {print user; exit}')

  if [[ -n "$user" ]]; then
    # \e[32m = green, \e[0m = reset
    echo -e "✔ Active acount: ${GREEN}$user${RESET}"
  fi
}
gs() {
  case "$1" in
  hasan | h)
    gh auth switch -u hasanmahmud7152
    ;;
  sujon | s | n)
    gh auth switch -u hasansujon786
    ;;
  *)
    gh_active_user
    echo ""
    echo "Switch Account:"
    echo "  gs hasan   → switch to hasanmahmud7152"
    echo "  gs sujon   → switch to hasansujon786"
    ;;
  esac
}

### Keybinds
##################################################
bind -m emacs-standard -x '"\es":find_alias'
bind -m vi-command -x '"\es":find_alias'
bind -m vi-insert -x '"\es":find_alias'

bind '"\eo":"\C-uyazi_cd\C-m"'
# bind '"\C-x\C-x":edit-and-execute-command'
