#!/bin/bash

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
compl() {
  printf "${CLR_GREEN}${STL_BOLD}>>>${CLR_RESET} ${STL_BOLD}%s${CLR_RESET}\n" "$1"
  shift
  for i in "$@"; do
    printf "  ${CLR_GREEN}${STL_BOLD}|${CLR_RESET} ${STL_BOLD}%s${CLR_RESET}\n" "$i"
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
has() {
  _cmd=$(command -v "$1") 2>/dev/null || return 1
  [ -x "$_cmd" ] || return 1
}

set -e

inputOsName=${1}
case "${inputOsName}" in
win) osIndex=0 ;;
lin) osIndex=1 ;;
ter) osIndex=2 ;;
*) osIndex=3 ;;
esac

case "${inputOsName}" in
win) os=windows ;;
lin) os=linux ;;
ter) os=termux ;;
*) os=linux ;;
esac

case "${inputOsName}" in
win) getter=choco ;;
lin) getter='sudo apt' ;;
ter) getter=apt ;;
*) getter=apt ;;
esac

if [[ $osIndex -eq 3 ]]; then
  echo "error: The following required arguments were not provided:"
  echo "USAGE:

  ./install [OS Name] (win/lin/ter)

    win: windows
    lin: linux
    ter: termux"
  exit 1
else
  echo "      _       _         __ _ _"
  echo "   __| | ___ | |_      / _(_) | ___  ___"
  echo "  / _\` |/ _ \| __|____| |_| | |/ _ \/ __|"
  echo " | (_| | (_) | ||_____|  _| | |  __/\__ \\"
  echo "  \__,_|\___/ \__|    |_| |_|_|\___||___/"
  echo ""

  echo \ System: ${os}
  echo \ Package manager: "$getter"
  echo \ OS Index: ${osIndex}
fi

###### utils ######
util_print() {
  echo ' '
  figlet \ "$1"
}
util_setup_figlet() {
  if [[ "$os" == "windows" ]]; then
    $getter install -y figlet-go
  else
    sudo apt update -y && sudo apt upgrade -y
    $getter install -y figlet
  fi
}
util_backUpConfig() {
  if [ -d "$1" ]; then
    echo 'Backeduped old directory.'
    mv "$1" "$1.bak.$(date +%Y.%m.%d-%H.%M.%S)"
  elif [ -f "$1" ]; then
    echo 'Backeduped old file.'
    mv "$1" "$1.bak.$(date +%Y.%m.%d-%H.%M.%S)"
  fi
}
util_makeSymlinkPath() {
  # $1 = actual path (from)
  # $2 = symlink path (to)
  if [[ "$os" == "windows" ]]; then
    powershell New-Item -ItemType SymbolicLink -Path "$2" -Target "$1"
  else
    ln -s "$1" "$2"
  fi
}

###### setup functions ######
setup_git_defaults() {
  gitconfigPath=("$HOME/.gitconfig" "$HOME/.gitconfig" "$HOME/.gitconfig")
  util_print git

  util_backUpConfig "${gitconfigPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/bash/.gitconfig" "${gitconfigPath[$osIndex]}"

  # echo ">> Type your github username."
  # read git_user_name
  # echo ">> Type your github email."
  # read git_user_email

  # git config --global user.email $git_user_email
  # git config --global user.name "$git_user_name"
  # git config --global credential.helper store

  # git config --global credential.helper 'cache --timeout=86400'
  # git credential-cache exit
}

setup_bash() {
  bashPath=("$HOME/.bashrc" "$HOME/.bashrc" "$HOME/.bashrc")
  util_print bash

  util_backUpConfig "${bashPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/bash/.bashrc" "${bashPath[$osIndex]}"

  util_print bash-utils
  $getter install -y fzf
  $getter install -y zoxide
  $getter install -y ripgrep
  $getter install -y fd
  $getter install -y wget
  $getter install -y curl
  # $getter install -y starship
}

setup_wezterm() {
  weztermPath=("$HOME/.config/wezterm" "$HOME/.config/wezterm" "$HOME/.config/wezterm")
  util_print wezterm
  $getter install wezterm -y

  git clone https://github.com/hasansujon786/wezterm-session-manager.git ~/.config/wezterm/wezterm-session-manager
  util_backUpConfig "${weztermPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/gui/wezterm" "${weztermPath[$osIndex]}"
}

setup_nvim() {
  nvimPath=("$HOME/AppData/Local/nvim" "$HOME/.config/nvim" "$HOME/.config/nvim")
  util_print nvim

  util_backUpConfig "${nvimPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/nvim" "${nvimPath[$osIndex]}"

  if [[ "$os" == "windows" ]]; then
    $getter install -y neovim
  else
    # wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    # chmod u+x nvim.appimage
    # sudo mv nvim.appimage ~/dotfiles/bin/nvim
    $getter install -y xclip
  fi
}

setup_lazygit() {
  lazygitPath=("$HOME/AppData/Roaming/lazygit" "$HOME/.config/lazygit" "$HOME/.config/lazygit")
  util_print lazygit

  util_backUpConfig "${lazygitPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/tui/lazygit" "${lazygitPath[$osIndex]}"

  if [[ "$os" == "windows" ]]; then
    $getter install -y lazygit
  elif [[ "$os" == "ter" ]]; then
    # install manually for termux
    mkdir -p ./lazy
    export LAZYGIT_VER="0.30.1"
    wget -O ./lazy/lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_arm64.tar.gz
    tar xvf ./lazy/lazygit.tgz -C ./lazy/
    mv ./lazy/lazygit /data/data/com.termux/files/usr/bin/lazygit
    rm -rf ./lazy
  else
    # install manually for linux
    mkdir -p ./lazy
    export LAZYGIT_VER="0.30.1"
    wget -O ./lazy/lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz
    tar xvf ./lazy/lazygit.tgz -C ./lazy/
    sudo mv ./lazy/lazygit /usr/local/bin/
    rm -rf ./lazy
  fi

}

setup_tig() {
  util_print tig
  if [[ "$os" == "windows" ]]; then
    $getter install -y tig
  fi
  ln -s ~/dotfiles/tui/tig/.tigrc ~/.tigrc
}

setup_lf() {
  # https://linoxide.com/lf-terminal-manager-linux/
  lfPath=("$HOME/AppData/Local/lf" "$HOME/.config/lf" "$HOME/.config/lf")
  util_print lf

  util_backUpConfig "${lfPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/tui/lf" "${lfPath[$osIndex]}"
  if [[ "$os" == "windows" ]]; then
    $getter install -y lf
  else
    wget https://github.com/gokcehan/lf/releases/download/r24/lf-linux-amd64.tar.gz -O lf-linux-amd64.tar.gz
    tar xvf lf-linux-amd64.tar.gz
    chmod +x lf
    sudo mv lf /usr/local/bin
    rm -rf lf-linux-amd64.tar.gz
    curl https://raw.githubusercontent.com/thameera/vimv/master/vimv >~/usr/local/bin/vimv && chmod +755 ~/usr/local/bin/vimv
    # install vimv
    sudo cp ~/dotfiles/tui/lf/vimv /usr/local/bin/
  fi
}

setup_yazi() {
  yaziPath=("$HOME/AppData/Roaming/yazi" "$HOME/.config/yazi" "$HOME/.config/yazi")
  util_print yazi

  util_backUpConfig "${yaziPath[$osIndex]}"
  mkdir -p "${yaziPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/tui/yazi" "${yaziPath[$osIndex]}/config"

  # if [[ "$os" == "windows" ]]; then
  # 	$getter install -y lf
  # else
  # fi
}

setup_alacritty() {
  alacrittyPath=("$HOME/AppData/Roaming/alacritty" "$HOME/.config/alacritty" "$HOME/.config/alacritty")
  util_print alacritty
  if [[ "$os" == "windows" ]]; then
    $getter install -y alacritty
  fi

  util_backUpConfig "${alacrittyPath[$osIndex]}"
  mkdir -p "${alacrittyPath[$osIndex]}"
  # util_makeSymlinkPath $HOME/dotfiles/alacritty ${alacrittyPath[$osIndex]}
  util_makeSymlinkPath "$HOME/dotfiles/alacritty/alacritty.$os.yml" "${alacrittyPath[$osIndex]}/alacritty.yml"
}

setup_node() {
  util_print nodejs
  # shellcheck source=/dev/null
  # curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -

  if [[ "$os" == "windows" ]]; then
    # $getter install -y nodejs
    # choco install nvm
    $getter install -y nodejs-lts
  elif [[ "$os" == "linux" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    nvm install 14
  fi
}

install_various_apps() {
  util_print python
  $getter install -y python
  # c:\python39\python.exe -m pip install --upgrade pip
  # pip install --user --upgrade pynvim
  python -m pip install --upgrade Pillow
  # python -m pip install --upgrade mupdf

  util_print rust
  $getter install -y rust
  # cargo install --list
  # cargo install vimv
  #
  $getter install -y eget
  $getter install -y onefetch
  $getter install -y scrcpy
  $getter install -y jq
  $getter install -y tldr

  # util_print taskwarrior
  # apt install taskwarrior
  # pip3 install tasklib
  # pip3 install six

  # util_print vit
  # pip3 install vit

  if [[ "$os" == "windows" ]]; then
    setup_keypirinha
    $getter install -y obsidian
    $getter install -y 7zip.install
    $getter install -y sharpkeys
    $getter install -y potplayer
    $getter install -y quicklook
    $getter install -y delta # git highlighter
    # $getter install -y instanteyedropper.app
    $getter install -y ntop.portable
    $getter install -y riot
    $getter install -y googlechrome
    setup_windowsTerminal
    setup_sublime
  elif [[ "$os" == "linux" ]]; then
    install_and_setup_tmux
  fi
}

setup_keypirinha() {
  # install path C:\ProgramData\chocolatey\lib\keypirinha\tools\Keypirinha
  keypirinhaPath=("$HOME/AppData/Roaming/Keypirinha")
  util_print keypirinha

  util_backUpConfig "${keypirinhaPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/gui/Keypirinha" "${keypirinhaPath[$osIndex]}"
  $getter install -y keypirinha
  C:\\ProgramData\\chocolatey\\lib\\keypirinha\\tools\\Keypirinha\\keypirinha.exe
}

setup_bugn() {
  bugnPath=("$HOME/AppData/Roaming/bug.n/Config.ini")
  util_print bug.n

  util_backUpConfig "${bugnPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/gui/bugn/Config.ini" "${bugnPath[$osIndex]}"
}

setup_ahk() {
  util_print main.ahk
  ahkPath="C:\\Users\\$USERNAME\\AppData\\Roaming\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\main.ahk"

  choco install autohotkey -y
  rm -rf "$ahkPath"
  util_makeSymlinkPath "$HOME/dotfiles/scripts/ahk/main.ahk" "'$ahkPath'"
  explorer "$ahkPath"
}

setup_sublime() {
  util_print sublime
  sublimePath="C:\\Users\\$USERNAME\\AppData\\Roaming\\Sublime Text\\Packages"

  $getter install -y sublimetext4
  mkdir -p "$sublimePath"
  rm -rf "$sublimePath\\User"
  rm -rf "$sublimePath\\Theme - One Dark"

  util_makeSymlinkPath "$HOME/dotfiles/gui/sublime_text/User" "'$sublimePath\\User'"
  util_makeSymlinkPath "$HOME/dotfiles/gui/sublime_text/theme" "'$sublimePath\\Theme - One Dark'"
}

# C:\Users\hasan\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
setup_windowsTerminal() {
  util_print WinTerminal
  wtPath=("$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState")
  # wtPathBeta=($HOME/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json)

  $getter install -y microsoft-windows-terminal # --pre

  mkdir -p "${wtPath[$osIndex]}"
  util_backUpConfig "${wtPath[$osIndex]}/settings.json"
  util_makeSymlinkPath "$HOME/dotfiles/windows-terminal/settings.json" "${wtPath[$osIndex]}/settings.json"
}

setup_pwsh() {
  util_print Pwsh
  pwshPath=("$HOME/Documents/PowerShell")

  $getter install pwsh -y

  util_backUpConfig "${pwshPath[$osIndex]}"
  util_makeSymlinkPath "$HOME/dotfiles/PowerShell" "${pwshPath[$osIndex]}"
}

install_and_setup_tmux() {
  # L => ~/.tmux.conf
  util_print tmux
  echo 'Instlling tmux...'
  $getter install -y tmux

  if [ -f ~/.tmux.conf ]; then
    echo 'Removing old .tmux.conf'
    rm ~/.tmux.conf
  fi

  echo 'Creating .tmux.conf'
  printf 'source-file ~/dotfiles/tmux/.tmux.conf' >>~/.tmux.conf
}

auto_install_everything() {
  echo ' ** Auto Install ** '
  mkdir -p ~/.config

  if [[ "$os" == "windows" ]]; then
    start ms-settings:developers
    $getter install -y brave
    setup_pwsh
    # setup_ahk
    $getter install -y mingw
    $getter install -y make
  elif [[ "$os" == "linux" ]]; then
    $getter install -y build-essential
    $getter install -y ninja-build
  fi

  setup_bash
  setup_wezterm
  setup_nvim
  setup_node
  # setup_alacritty
  setup_lazygit
  setup_lf
  setup_yazi
  # setup_tig
  # setup_git_defaults
  install_various_apps
}

prompt_and_get_answers() {
  util_setup_figlet
  auto_install_everything

  util_print done.
}

prompt_and_get_answers
