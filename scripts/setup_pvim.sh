#!/bin/bash

util_makeSymlinkPath() {
	# $1 = actual path (from)
	# $2 = symlink path (to)
	if [[ "$os" == "windows" ]]; then
		powershell New-Item -ItemType SymbolicLink -Path "$2" -Target "$1"
	else
		ln -s "$1" "$2"
	fi
}

rm -rf "$HOME/pvim/config"
util_makeSymlinkPath "$HOME/dotfiles/nvim" "$HOME/pvim/config"
