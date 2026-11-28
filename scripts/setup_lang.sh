#!/usr/bin/env bash

# ------------------------------------------------
# -- Install and set up development languages -----
# ------------------------------------------------
# Usage:
#   ./setup_lang.sh flutter python rust node
#   ./setup_lang.sh --all
#
# Environment overrides:
#   PURO_VERSION=1.5.0       Version of Puro to install when missing
#   PURO_ENV=stable          Puro environment name to create/use
#   FLUTTER_VERSION=stable   Flutter channel/version for that environment

set -euo pipefail

# ------------------------------------------------
# -- Config --------------------------------------
# ------------------------------------------------
OS="Unknown"
PACKAGE_MANAGER="none"
PURO_VERSION="${PURO_VERSION:-1.5.0}"
PURO_ENV="${PURO_ENV:-stable}"
FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"

declare -A system_name
system_name[win]="Windows"
system_name[lin]="Linux"
system_name[mac]="MacOS"
system_name[Unknown]="Unknown"

ALL_LANGUAGES=(flutter python rust node)

# ------------------------------------------------
# -- Utils ---------------------------------------
# ------------------------------------------------
info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*" >&2; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }

heading() {
  echo " "
  if command -v figlet &>/dev/null; then
    figlet "$1"
  else
    echo "== $1 =="
  fi
}

trap 'error "Something went wrong at line $LINENO. Exiting."' ERR

usage() {
  cat <<'EOF'
Usage:
  ./setup_lang.sh flutter python rust node
  ./setup_lang.sh --all

Supported languages:
  flutter  git + Puro, then create/upgrade/use a Flutter environment
  python   python + pipx + uv, and upgrade pip
  rust     rust + rustfmt/clippy components
  node     nodejs-lts + npm globals (yarn, trash-cli, live-server)

Options:
  --all       Set up every supported language
  -h, --help  Show this help

Environment overrides:
  PURO_VERSION      Puro version to install (default: 1.5.0)
  PURO_ENV          Puro environment name (default: stable)
  FLUTTER_VERSION   Flutter channel/version (default: stable)
EOF
}

detect_os() {
  case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*)
    OS="win"
    PACKAGE_MANAGER="scoop"
    ;;
  # Keep the same supported systems as scripts/install.sh.
  # Linux*)
  #   OS="lin"
  #   PACKAGE_MANAGER="apt"
  #   ;;
  # Darwin*)
  #   OS="mac"
  #   PACKAGE_MANAGER="brew"
  #   ;;
  *)
    OS="Unknown"
    PACKAGE_MANAGER="none"
    ;;
  esac

  echo "      _       _         __ _ _"
  echo "   __| | ___ | |_      / _(_) | ___  ___"
  echo "  / _\` |/ _ \\| __|____| |_| | |/ _ \\/ __|"
  echo " | (_| | (_) | ||_____|  _| | |  __/\\__ \\"
  echo "  \\__,_|\\___/ \\__|    |_| |_|_|\\___||___/"
  echo ""
  echo -e "  \033[1;34mSystem:\033[0m ${system_name[${OS}]} (${OS})"
  echo -e "  \033[1;34mPackage manager:\033[0m ${PACKAGE_MANAGER}"
  echo ""
}

add_to_path() {
  local dir
  for dir in "$@"; do
    if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
      info "Adding to current PATH: $dir"
      export PATH="$dir:$PATH"
    fi
  done
}

is_installed() {
  local cmd="$1"
  local label="${2:-$1}"

  if command -v "$cmd" &>/dev/null; then
    local version_info=""
    version_info=$("$cmd" --version 2>/dev/null || "$cmd" -v 2>/dev/null || true)
    version_info="${version_info%%$'\n'*}"

    if [[ -n "$version_info" ]]; then
      info "$label is already installed ($version_info)."
    else
      info "$label is already installed."
    fi
    return 0
  fi

  return 1
}

get() {
  for pkg in "$@"; do
    info "Installing $pkg..."
    scoop install "$pkg"
    success "$pkg installed successfully."
  done
}

ensure_installed() {
  local pkg="$1"
  local exe="${2:-$1}"

  if is_installed "$exe"; then
    info "Found $exe. Skipping install."
  else
    get "$pkg"
  fi
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
  fi
}

setup_package_manager() {
  if [[ "$PACKAGE_MANAGER" != "scoop" ]]; then
    error "Package manager '$PACKAGE_MANAGER' is not supported by this script."
    trap '' ERR
    return 1
  fi

  if ! command -v scoop &>/dev/null; then
    error "Scoop is not installed. Install it from https://scoop.sh/ and run this script again."
    trap '' ERR
    return 1
  fi

  ensure_scoop_bucket extras
}

# ------------------------------------------------
# -- Flutter -------------------------------------
# ------------------------------------------------
install_puro() {
  local tmp_exe tmp_unix

  info "Installing Puro $PURO_VERSION..."
  tmp_exe="$(powershell.exe -NoProfile -Command 'Write-Output (Join-Path $env:TEMP "puro.exe")' | tr -d '\r')"

  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "
    \$ErrorActionPreference = 'Stop'
    Invoke-WebRequest -Uri 'https://puro.dev/builds/$PURO_VERSION/windows-x64/puro.exe' -OutFile '$tmp_exe'
    & '$tmp_exe' install-puro --promote
  "

  tmp_unix="$tmp_exe"
  if command -v cygpath &>/dev/null; then
    tmp_unix="$(cygpath -u "$tmp_exe")"
  fi
  rm -f "$tmp_unix" 2>/dev/null || true

  # Puro updates the persistent PATH, but the current shell needs the update too.
  add_to_path "$HOME/.puro/bin" "$HOME/.puro"

  success "Puro installed. Restart your shell/IDE if puro is not found yet."
}

puro_has_env() {
  local env_name="$1"
  puro ls 2>/dev/null | awk -v name="$env_name" '
    {
      gsub(/[~*]/, "", $0)
      if ($1 == name && $0 !~ /not installed/) found = 1
    }
    END { exit(found ? 0 : 1) }
  '
}

setup_flutter() {
  heading flutter

  ensure_installed git git

  if ! is_installed puro "Puro"; then
    if [[ "$OS" != "win" ]]; then
      error "Automatic Puro installation is only implemented for Windows."
      error "Install Puro from https://puro.dev/ and run this script again."
      return 1
    fi
    install_puro
  fi

  if ! is_installed puro "Puro"; then
    error "puro is not available on PATH after installation. Restart your shell and retry."
    return 1
  fi

  if puro_has_env "$PURO_ENV"; then
    info "Puro environment '$PURO_ENV' already exists. Skipping create."
  else
    info "Creating Puro environment '$PURO_ENV' from '$FLUTTER_VERSION'..."
    puro create "$PURO_ENV" "$FLUTTER_VERSION"
  fi

  info "Upgrading Puro environment '$PURO_ENV'..."
  puro upgrade "$PURO_ENV"

  if [[ -f pubspec.yaml ]]; then
    puro use "$PURO_ENV"
  else
    info "Not inside a Flutter project; skipping project-level 'puro use'."
  fi
  puro use -g "$PURO_ENV"

  success "Flutter environment '$PURO_ENV' is ready."
  warn "Restart your shell/IDE if 'flutter' or 'dart' are not on PATH yet."
}

# ------------------------------------------------
# -- Python --------------------------------------
# ------------------------------------------------
setup_python() {
  heading python

  ensure_installed python python

  if ! is_installed python "Python"; then
    error "python is not available after installation."
    return 1
  fi

  info "Upgrading pip..."
  python -m pip install --upgrade pip

  # Scoop packages keep these isolated from project virtualenvs.
  ensure_installed pipx pipx
  ensure_installed uv uv

  success "Python is ready. Use 'uv venv' or 'pipx install <tool>' for project tools."
}

# ------------------------------------------------
# -- Rust ----------------------------------------
# ------------------------------------------------
setup_rust() {
  heading rust

  ensure_installed rust cargo

  if ! is_installed cargo "Cargo"; then
    error "cargo is not available after installation."
    return 1
  fi

  if command -v rustup &>/dev/null; then
    info "Ensuring rustfmt and clippy are installed..."
    rustup component add rustfmt clippy
  else
    warn "rustup not found; skipping rustfmt/clippy setup."
  fi

  success "Rust is ready."
}

# ------------------------------------------------
# -- Node ----------------------------------------
# ------------------------------------------------
setup_node() {
  heading nodejs

  if ! is_installed node "Node.js"; then
    get nodejs-lts

    # nodejs-lts relies on Scoop's env_add_path, so npm is not on PATH until a
    # new shell starts. Add its directories to this shell too.
    local node_dir="$HOME/scoop/apps/nodejs-lts/current"
    add_to_path "$node_dir" "$node_dir/bin"
  fi

  if ! is_installed node "Node.js"; then
    error "node is not available after installation."
    return 1
  fi

  if ! is_installed npm "npm"; then
    error "npm is not available after installing Node.js. Restart your shell and retry."
    return 1
  fi

  info "Installing useful global npm packages..."
  npm install -g yarn trash-cli live-server

  success "Node.js is ready."
}

# ------------------------------------------------
# -- Main ----------------------------------------
# ------------------------------------------------
main() {
  local arg
  local -A selected
  local -a languages

  case "${1:-}" in
  -h | --help)
    usage
    return 0
    ;;
  esac

  detect_os
  setup_package_manager

  if [[ "${1:-}" == "--all" ]]; then
    languages=("${ALL_LANGUAGES[@]}")
  else
    for arg in "$@"; do
      case "$arg" in
      flutter | python | rust | node)
        if [[ -z "${selected[$arg]:-}" ]]; then
          selected[$arg]=1
          languages+=("$arg")
        fi
        ;;
      -h | --help)
        usage
        return 0
        ;;
      *)
        error "Unknown language or option: $arg"
        usage >&2
        trap '' ERR
        return 1
        ;;
      esac
    done
  fi

  if [[ ${#languages[@]} -eq 0 ]]; then
    error "No languages selected."
    usage >&2
    trap '' ERR
    return 1
  fi

  info "Setting up: ${languages[*]}"

  for arg in "${languages[@]}"; do
    case "$arg" in
    flutter) setup_flutter ;;
    python) setup_python ;;
    rust) setup_rust ;;
    node) setup_node ;;
    esac
  done

  success "Done: ${languages[*]}"
}

main "$@"
