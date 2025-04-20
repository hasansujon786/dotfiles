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
NVIM_CONFIG_DIR="$HOME/AppData/Local/nvim"
NVIM_PACKAGES_DIR="$HOME/AppData/Local/nvim-data/packages"

# Check if dotfiles config exists
if [ ! -d "$DOTFILES" ]; then
  error "Config directory $DOTFILES does not exist."
  exit 1
fi

mkdir -p "$NVIM_PACKAGES_DIR"

# # dart
# cd C:\\Users\\$USERNAME\\AppData\\Local\\nvim-data\\dap_adapters\\
# export DART_CODE_VER="3.56.0"
# curl -O -J -L https://codeload.github.com/Dart-Code/Dart-Code/zip/refs/tags/v${DART_CODE_VER}
# unzip Dart-Code-${DART_CODE_VER}.zip && mv Dart-Code-${DART_CODE_VER} Dart-Code && cd Dart-Code
# npm install && npm run build
# cd .. && rm Dart-Code-${DART_CODE_VER}.zip
#

vscode-js-debug() {
  info "Installing vscode-js-debug..."
  export VSCODE_JS_VER="1.85.0"

  cd "$NVIM_PACKAGES_DIR" || exit
  rm -rf vscode-js-debug

  curl -O -J -L https://codeload.github.com/microsoft/vscode-js-debug/zip/refs/tags/v${VSCODE_JS_VER}
  unzip vscode-js-debug-${VSCODE_JS_VER}.zip && mv vscode-js-debug-${VSCODE_JS_VER} vscode-js-debug && cd vscode-js-debug || exit
  npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out
  cd .. && rm vscode-js-debug-${VSCODE_JS_VER}.zip

  success "vscode-js-debug installed successfully"
}

autohotkey2() {
  info "Installing vscode-autohotkey2-lsp..."

  cd "$NVIM_PACKAGES_DIR" || exit
  rm -rf vscode-autohotkey2-lsp
  mkdir -p vscode-autohotkey2-lsp

  cd vscode-autohotkey2-lsp || exit
  curl -fsLo install.js https://raw.githubusercontent.com/thqby/vscode-autohotkey2-lsp/main/tools/install.js
  node install.js

  success "vscode-autohotkey2-lsp installed successfully"
}

main() {
  # autohotkey2
  vscode-js-debug
}

main
