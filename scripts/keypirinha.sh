#!/bin/bash
os=windows
# install path C:\ProgramData\chocolatey\lib\keypirinha\tools\Keypirinha

util_makeSymlinkPath() {
	# $1 = actual path (from)
	# $2 = symlink path (to)
	if [[ "$os" == "windows" ]]; then
		powershell New-Item -ItemType SymbolicLink -Path "$2" -Target "$1"
	else
		ln -s "$1" "$2"
	fi
}

choco uninstall -y keypirinha
# rm -rf "$HOME/AppData/Roaming/Keypirinha"
# util_makeSymlinkPath "$HOME/dotfiles/gui/Keypirinha" "$HOME/AppData/Roaming/Keypirinha"
choco install -y keypirinha
C:\\ProgramData\\chocolatey\\lib\\keypirinha\\tools\\Keypirinha\\keypirinha.exe
