#!/bin/sh
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

die() {
  printf "${CLR_RED}${STL_BOLD}error:${CLR_RESET} ${STL_BOLD}%s${CLR_RESET}\n" "$1"
  shift
  for i in "$@"; do
    printf "     ${CLR_RED}${STL_BOLD}|${CLR_RESET} ${STL_BOLD}%s${CLR_RESET}\n" "$i"
  done
  exit 1
}


runner="npm"

if [[ -f ./package.json ]]; then
  if [[ -f ./yarn.lock ]]; then
    runner="yarn"
  fi
  msg "using $runner"
else
  die "no package.json"
fi

script=$(cat package.json | jq -r '.scripts | keys[] ' | sort | fzf --border-label='Script Commands') && $runner $(echo "$script")
