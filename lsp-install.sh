#!/bin/bash
##!/bin/sh

set -e

input=$1
case "${input}" in
  win)     machineCode=0;;
  lin)     machineCode=1;;
  ter)     machineCode=2;;
    *)     machineCode=3
esac

if [[ $machineCode -eq 3 ]]; then
  echo "error: The following required arguments were not provided:"
  echo "USAGE:

  ./lsp-install [OS Name] (win/lin/ter)

    win: windows
    lin: linux
    ter: termux"
  exit 1
else
  case "${input}" in
    win)  machine=windows;;
    lin)  machine=linux;;
    ter)  machine=termux;;
    *)    machine=linux
  esac

  case "${input}" in
    win)  getter=choco;;
    lin)  getter='sudo apt';;
    ter)  getter=apt;;
    *)    getter=apt
  esac

  echo \ System: ${machine}
  echo \ Package manager: ${getter}
  echo \ code: ${machineCode}
fi

###### utils ######
util_backUpConfig() {
  if [ -d $1 ]; then
    echo 'Removing old directory.'
    mv $1 "$1.bak.$(date +%Y.%m.%d-%H.%M.%S)"
  elif [ -f $1 ]; then
    echo 'Removing old file.'
    mv $1 "$1.bak.$(date +%Y.%m.%d-%H.%M.%S)"
  fi
}
util_makeSymlinkPath() {
  # $1 = actual path (from)
  # $2 = symlink path (to)
  if [[ "$machine" == "windows" ]]; then
    powershell New-Item -ItemType SymbolicLink -Path "$2" -Target "$1"
  else
    ln -s $1 $2
  fi
}

if [[ "$machine" == "windows" ]]; then
  localServerPath=~/AppData/**
else
  localServerPath=/home/hasan/.local/share/nvim/lsp-servers
fi
mkdir -p $localServerPath

###### setup functions ######
setup_tsserver() {
  npm install -g typescript typescript-language-server
}

setup_tailwindcss-ls() {
  tw_path=$localServerPath/tailwindcss-ls
  mkdir -p $tw_path
  cd $tw_path
  curl -L -o tailwindcss-intellisense.vsix https://github.com/tailwindlabs/tailwindcss-intellisense/releases/download/v0.6.13/vscode-tailwindcss-0.6.13.vsix
  unzip tailwindcss-intellisense.vsix -d tailwindcss-intellisense
  echo "#\!/usr/bin/env node\n$(cat tailwindcss-intellisense/extension/dist/server/tailwindServer.js)" > tailwindcss-language-server
  chmod +x tailwindcss-language-server
}

# sudo apt install ninja-build
setup_sumneko_lua() {
  lua_path=$localServerPath/sumneko_lua
  mkdir -p $lua_path
  cd $lua_path

  # clone project
  git clone https://github.com/sumneko/lua-language-server
  cd lua-language-server
  git submodule update --init --recursive
  cd 3rd/luamake
  compile/install.sh
  cd ../..
  ./3rd/luamake/luamake rebuild
}

# setup_tsserver
# setup_tailwindcss-ls


