#!/usr/bin/env bash

# Exit immediately if a command fails
set -euo pipefail

# ------------------------------------------------
# -- Utils fucntios ------------------------------
# ------------------------------------------------
# Colored output for readability
info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }
# Output big title
heading() {
  echo " "
  figlet \ "$1"
}
archive_config() {
  info "Backing up... $1"
  if [ -d "$1" ]; then
    mv "$1" "$1.bak.$(date +%Y.%m.%d-%H.%M.%S)"
  elif [ -f "$1" ]; then
    mv "$1" "$1.bak.$(date +%Y.%m.%d-%H.%M.%S)"
  fi
}
create_symlink() {
  info "Creating symlink: $1 -> $2"
  # $1 = symlink path (to)
  # $2 = actual path (from)
  if [[ "$OS" == "win" ]]; then
    powershell New-Item -ItemType SymbolicLink -Path "$1" -Target "$2"
  else
    ln -s "$1" "$2"
  fi
}
update_path_var() {
  # Safely check if argument is provided using ${1:-}
  if [ -z "${1:-}" ]; then
    error "Missing argument. Usage: update_path_var <path-to-add>"
    return 1
  fi

  local NEW_PATH="$1"
  local SCRIPT="C:\\Users\\$USERNAME\\dotfiles\\scripts\\variable_update_path.ps1"

  info "Updating PATH with: $NEW_PATH"

  powershell.exe -File "$SCRIPT" -newPath "$NEW_PATH"
  local status=$?

  if [ $status -ne 0 ]; then
    error "Failed to update PATH. PowerShell exited with status $status."
    return $status
  fi
}
create_user_var() {
  # Safely check if both arguments are provided
  if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
    error "Missing arguments. Usage: create_user_var <variable-name> <variable-value>"
    return 1
  fi

  local VAR_NAME="$1"
  local VAR_VALUE="$2"
  local SCRIPT="C:\\Users\\$USERNAME\\dotfiles\\scripts\\variable_create.ps1"

  info "Creating user environment variable: $VAR_NAME=$VAR_VALUE"

  powershell.exe -File "$SCRIPT" -varName "$VAR_NAME" -varValue "$VAR_VALUE"
  local status=$?

  if [ $status -ne 0 ]; then
    error "Failed to create environment variable. PowerShell exited with status $status."
    return $status
  fi
}
get() {
  for pkg in "$@"; do
    info "Installing $pkg..."

    if scoop install "$pkg"; then
      success "$pkg installed successfully."
    else
      error "Failed to install $pkg."
      return 1
    fi
  done
}
ensure_scoop_bucket() {
  local bucket_name="${1:-}"

  if [ -z "$bucket_name" ]; then
    error "Missing argument. Usage: ensure_scoop_bucket <bucket-name>"
    return 1
  fi

  if scoop bucket list | awk '{print $1}' | grep -q "^$bucket_name$"; then
    info "Found Scoop bucket: '$bucket_name'"
  else
    info "Adding Scoop bucket: $bucket_name..."
    scoop bucket add "$bucket_name"
    local status=$?
    if [ $status -ne 0 ]; then
      error "Failed to add bucket: $bucket_name"
      return $status
    fi
  fi
}

trap 'error "Something went wrong. Exiting."' ERR

detect_os() {
  case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*)
    OS="win"
    SYSTEM="Windows"
    PACKAGE_MANAGER="scoop"
    ;;
  # Linux*)
  #   OS="lin"
  #   SYSTEM="Linux"
  #   PACKAGE_MANAGER="apt"
  #   ;;
  # Darwin*)
  #   OS="mac"
  #   SYSTEM="macOS"
  #   PACKAGE_MANAGER="brew"
  #   ;;
  *)
    OS="Unknown"
    SYSTEM="Unknown"
    PACKAGE_MANAGER="none"
    ;;
  esac

  echo "      _       _         __ _ _"
  echo "   __| | ___ | |_      / _(_) | ___  ___"
  echo "  / _\` |/ _ \| __|____| |_| | |/ _ \/ __|"
  echo " | (_| | (_) | ||_____|  _| | |  __/\__ \\"
  echo "  \__,_|\___/ \__|    |_| |_|_|\___||___/"
  echo ""
  echo -e "  \033[1;34mSystem:\033[0m ${SYSTEM} (${OS})"
  echo -e "  \033[1;34mPackage manager:\033[0m ${PACKAGE_MANAGER}"
  echo ""
}
detect_os

# Exit if it isn't one of the supported system
if [[ "$OS" == 'Unknown' ]]; then
  error "System $(uname -s) is not supported"
  exit 1
fi

# ------------------------------------------------
# -- Config paths --------------------------------
# ------------------------------------------------
DOTFILES="$HOME/dotfiles"
WINDOWS_STARTUP_DIR="C:\\Users\\${USERNAME}\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"
NVIM_CONFIG_DIR="$HOME/AppData/Local/nvim"
NVIM_PACKAGES_DIR="$HOME/AppData/Local/nvim-data/packages"

# Install scoop with powershell => Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; iwr -useb get.scoop.sh | iex
# Check if Scoop is installed
HAS_SCOOP=false
if [[ "$PACKAGE_MANAGER" == 'scoop' ]] && command -v scoop &>/dev/null; then
  HAS_SCOOP=true
  ensure_scoop_bucket extras
else
  error "Scoop is not installed. Please install Scoop first."
  exit 1
fi

# Check if dotfiles config exists
if [ ! -d "$DOTFILES" ]; then
  error "Config directory $DOTFILES does not exist."
  exit 1
fi

init_setup() {
  if ! command -v figlet &>/dev/null; then
    get figlet
  fi

  if [[ "$OS" == "win" ]]; then
    start ms-settings:developers
    mkdir -p ~/.config

    update_path_var "C:\Users\\$USERNAME\dotfiles\.bin"
    create_user_var ANDROID_HOME "$LOCALAPPDATA\Android\Sdk"
  fi
}

# ------------------------------------------------
# -- Setup TUI & CLI Apps ------------------------
# ------------------------------------------------
setup_git() {
  declare -A conf_path
  conf_path[win]="$HOME/.gitconfig"
  conf_path[lin]="$HOME/.gitconfig"

  heading git

  archive_config "${conf_path[$OS]}"
  create_symlink "${conf_path[$OS]}" "$HOME/dotfiles/bash/.gitconfig"
}
setup_bash() {
  declare -A conf_path
  conf_path[win]="$HOME/.bashrc"
  conf_path[lin]="$HOME/.bashrc"

  heading bash

  archive_config "${conf_path[$OS]}"
  create_symlink "${conf_path[$OS]}" "$HOME/dotfiles/bash/.bashrc"
}
setup_pwsh() {
  declare -A conf_path
  conf_path[win]="$HOME/Documents/PowerShell"

  heading pwsh
  get pwsh

  archive_config "${conf_path[$OS]}"
  create_symlink "${conf_path[$OS]}" "$HOME/dotfiles/PowerShell"
}
setup_nvim() {
  declare -A conf_path
  conf_path[win]="$HOME/AppData/Local/nvim"
  conf_path[lin]="$HOME/.config/nvim"

  heading nvim
  get neovim

  archive_config "${conf_path[$OS]}"
  create_symlink "${conf_path[$OS]}" "$HOME/dotfiles/nvim"
}
setup_lazygit() {
  declare -A conf_path
  conf_path[win]="$HOME/AppData/Local/lazygit"
  conf_path[lin]="$HOME/.config/lazygit"

  heading lazygit
  get lazygit

  archive_config "${conf_path[$OS]}"
  create_symlink "${conf_path[$OS]}" "$HOME/dotfiles/tui/lazygit"
}
setup_yazi() {
  # TODO: Get a bookmar manager
  declare -A conf_path
  conf_path[win]="$HOME/AppData/Roaming/yazi"
  conf_path[lin]="$HOME/.config/yazi"

  heading yazi
  get yazi

  mkdir -p "${conf_path[$OS]}"
  archive_config "${conf_path[$OS]}/config"
  create_symlink "${conf_path[$OS]}/config" "$HOME/dotfiles/tui/yazi"
}
setup_autohotkey() {
  if [[ "$OS" == "win" ]]; then
    heading autohotkey
    get autohotkey

    rm -rf "$WINDOWS_STARTUP_DIR\\main.ahk"
    create_symlink "'$WINDOWS_STARTUP_DIR\\main.ahk'" "$HOME/dotfiles/scripts/ahk/main.ahk"
    explorer "$WINDOWS_STARTUP_DIR\\main.ahk"
  fi
}
setup_kanata() {
  if [[ "$OS" == "win" ]]; then
    declare -A conf_path
    conf_path[win]="$HOME/AppData/Roaming/kanata-tray"
    conf_path[lin]="$HOME/.config/kanata-tray"

    heading kanata
    get kanata

    archive_config "${conf_path[$OS]}"
    create_symlink "${conf_path[$OS]}" "$HOME/dotfiles/scripts/kanata/kanata-tray"

    rm -rf "$WINDOWS_STARTUP_DIR\\kanata-tray.exe"

    local KANATA_TRAY_VER="0.6.0"
    wget https://github.com/rszyma/kanata-tray/releases/download/v${KANATA_TRAY_VER}/kanata-tray.exe
    mv kanata-tray.exe "$WINDOWS_STARTUP_DIR"

    sleep 0.5
    explorer "${WINDOWS_STARTUP_DIR}\\kanata-tray.exe"
  fi
}
install_various_cli_apps() {
  heading "Usefull CLI Apps"
  get wget curl fd ripgrep zoxide fzf delta jq eza

  if [[ "$OS" == "win" ]]; then
    get mingw make

    # htop-like system-monitor
    get ntop btop
  fi

  # Easily install prebuilt binaries from GitHub. Ex: eget junegunn/fzf
  get eget

  # Git repository summary on terminal
  get onefetch
  get tokei

  # Display and control your Android device => https://github.com/Genymobile/scrcpy
  # check QtScrcpy a gui for scrcpy
  get scrcpy

  # Some necessary tools
  get tldr fastfetch
}

# ------------------------------------------------
# -- Setup GUI Apps ------------------------------
# ------------------------------------------------
setup_wezterm() {
  declare -A conf_path
  conf_path[win]="$HOME/.config/wezterm"
  conf_path[lin]="$HOME/.config/wezterm"

  heading wezterm
  get wezterm

  archive_config "${conf_path[$OS]}"
  create_symlink "${conf_path[$OS]}" "$HOME/dotfiles/gui/wezterm"
}
setup_sublime() {
  declare -A conf_path
  conf_path[win]="C:\\Users\\$USERNAME\\AppData\\Roaming\\Sublime Text\\Packages"
  conf_path[win_scoop]="C:\\Users\\$USERNAME\\scoop\\persist\\sublime-text\\Data\\Packages"
  # C:/Users/hasan/scoop/persist/sublime-text/Data/Packages

  heading sublime
  get sublime-text

  if [[ "$HAS_SCOOP" == "true" && "$OS" == "win" ]]; then
    mkdir -p "${conf_path[win_scoop]}"
    rm -rf "${conf_path[win_scoop]}/User"
    rm -rf "${conf_path[win_scoop]}/Theme - One Dark"

    create_symlink "${conf_path[win_scoop]}\\User" "$HOME/dotfiles/gui/sublime_text/User"
    create_symlink "'${conf_path[win_scoop]}\\Theme - One Dark'" "$HOME/dotfiles/gui/sublime_text/theme"
  # elif [[ "$OS" == "win" ]]; then
  #   mkdir -p "${conf_path[$OS]}"
  #   rm -rf "${conf_path[$OS]}/User"
  #   rm -rf "${conf_path[$OS]}/Theme - One Dark"

  #   create_symlink "'${conf_path[$OS]}/User'" "$HOME/dotfiles/gui/sublime_text/User"
  #   create_symlink "'${conf_path[$OS]}/Theme - One Dark'" "$HOME/dotfiles/gui/sublime_text/theme"
  fi

  info "Tip: Press ctrl+shift+p => And install package controll"
}
install_various_gui_apps() {
  heading "Usefull GUI Apps"

  if [[ "$OS" == "win" ]]; then
    # A utility that manages a Registry key that allows Windows to remap one key to any other key.
    get sharpkeys

    # FIXME: riot
    get obsidian potplayer quicklook instant-eyedropper localsend
    get googlechrome brave abdownloadmanager qbittorrent

    # Potplayer
    get potplayer
    reg.exe import "C:\\Users\\$USERNAME\\dotfiles\\scripts\\PotPlayerMini64.reg"
  fi
}

# ------------------------------------------------
# -- Language setups -----------------------------
# ------------------------------------------------
setup_node() {
  heading nodejs

  # fnm a Cross-platform Node.js version switcher
  get fnm
  fnm install lts-latest
  fnm use lts-latest

  info "Installing useful global npm packages..."
  npm install -g yarn trash-cli live-server
  # To auto channge node env use "fnm env --use-on-cd | Out-String | Invoke-Expression" to your powershell profile.
  # For example, if a project has .nvmrc or .node-version, fnm will detect and activate that version.
}
setup_rust() {
  heading rust
  get rust
}
setup_python() {
  heading python
  get python
}

# kanata tig lf alacritty windowsTerminal keypirinha
main() {
  init_setup

  # CLI & TUI Apps
  setup_git
  setup_bash
  setup_node # install before cause some installation can be depend on node
  install_various_cli_apps
  setup_nvim
  setup_autohotkey
  setup_yazi
  setup_lazygit
  setup_pwsh
  setup_kanata

  # GUI Apps
  setup_wezterm
  setup_sublime
  install_various_gui_apps

  # Language
  setup_rust
  setup_python
}

main
