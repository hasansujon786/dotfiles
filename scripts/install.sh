#!/bin/sh

set -e

inputOsName=${1}
case "${inputOsName}" in
  win)     osIndex=0;;
  lin)     osIndex=1;;
  ter)     osIndex=2;;
    *)     osIndex=3
esac

case "${inputOsName}" in
  win)  os=windows;;
  lin)  os=linux;;
  ter)  os=termux;;
  *)    os=linux
esac

case "${inputOsName}" in
  win)  getter=choco;;
  lin)  getter='sudo apt';;
  ter)  getter=apt;;
  *)    getter=apt
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
  echo \ Package manager: ${getter}
  echo \ OS Index: ${osIndex}
fi

###### utils ######
util_print() {
  echo ' '
  figlet \ $1
}
util_setup_figlet() {
  if [[ "$os" == "windows" ]]; then
    $getter install -y figlet-go
  else
    sudo apt upgrade && sudo apt update
    $getter install -y figlet
  fi
}
util_backUpConfig() {
  if [ -d $1 ]; then
    echo 'Backeduped old directory.'
    mv $1 "$1.bak.$(date +%Y.%m.%d-%H.%M.%S)"
  elif [ -f $1 ]; then
    echo 'Backeduped old file.'
    mv $1 "$1.bak.$(date +%Y.%m.%d-%H.%M.%S)"
  fi
}
util_makeSymlinkPath() {
  # $1 = actual path (from)
  # $2 = symlink path (to)
  if [[ "$os" == "windows" ]]; then
    powershell New-Item -ItemType SymbolicLink -Path "$2" -Target "$1"
  else
    ln -s $1 $2
  fi
}


###### setup functions ######
setup_git_defaults() {
  util_print git

  echo ">> Type your github username."
  read git_user_name
  echo ">> Type your github email."
  read git_user_email

  git config --global user.email $git_user_email
  git config --global user.name "$git_user_name"
  git config --global credential.helper store

  # git config --global credential.helper 'cache --timeout=86400'
  # git credential-cache exit
}

setup_bash() {
  bashPath=($HOME/.bashrc $HOME/.bashrc $HOME/.bashrc)
  util_print bash

  $getter install -y starship
  $getter install -y fzf
  util_backUpConfig ${bashPath[$osIndex]}
  util_makeSymlinkPath $HOME/dotfiles/bash/.bashrc ${bashPath[$osIndex]}
}

setup_wezterm() {
  weztermPath=($HOME/.wezterm.lua $HOME/.config/wezterm/wezterm.lua $HOME/.config/wezterm/wezterm.lua)
  util_print wezterm

  util_backUpConfig ${weztermPath[$osIndex]}
  util_makeSymlinkPath $HOME/dotfiles/gui/wezterm/.wezterm.lua ${weztermPath[$osIndex]}
}

setup_nvim() {
  nvimPath=($HOME/AppData/Local/nvim $HOME/.config/nvim $HOME/.config/nvim)
  util_print nvim

  util_backUpConfig ${nvimPath[$osIndex]}
  util_makeSymlinkPath $HOME/dotfiles/nvim ${nvimPath[$osIndex]}

  if [[ "$os" == "windows" ]]; then
    $getter install -y neovim
  else
    # wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    # chmod u+x nvim.appimage
    # sudo mv nvim.appimage ~/dotfiles/bin/nvim
    $getter install -y xclip
  fi

  packerPath=($HOME/AppData/Local/nvim-data/site/pack/packer/start/packer.nvim, $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim)
  if [ -d ${packerPath[$osIndex]} ]; then
    echo 'packer.nvim already exists'
  else
    echo 'cloning packer.nvim'
    mkdir -p ${packerPath[$osIndex]}
    git clone https://github.com/wbthomason/packer.nvim ${packerPath[$osIndex]}
  fi
  # echo "Installing vim plugins..."
  # nvim +PlugInstall +qall
}

setup_lazygit () {
  lazygitPath=($HOME/AppData/Roaming/lazygit $HOME/.config/lazygit $HOME/.config/lazygit)
  util_print lazygit

  util_backUpConfig ${lazygitPath[$osIndex]}
  util_makeSymlinkPath $HOME/dotfiles/tui/lazygit ${lazygitPath[$osIndex]}

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
  lfPath=($HOME/AppData/Local/lf $HOME/.config/lf $HOME/.config/lf)
  util_print lf

  util_backUpConfig ${lfPath[$osIndex]}
  util_makeSymlinkPath $HOME/dotfiles/tui/lf ${lfPath[$osIndex]}
  if [[ "$os" == "windows" ]]; then
    $getter install -y lf
  else
    wget https://github.com/gokcehan/lf/releases/download/r24/lf-linux-amd64.tar.gz -O lf-linux-amd64.tar.gz
    tar xvf lf-linux-amd64.tar.gz
    chmod +x lf
    sudo mv lf /usr/local/bin
    rm -rf lf-linux-amd64.tar.gz
    curl https://raw.githubusercontent.com/thameera/vimv/master/vimv > ~/usr/local/bin/vimv && chmod +755 ~/usr/local/bin/vimv
    # install vimv
    sudo cp ~/dotfiles/tui/lf/vimv /usr/local/bin/
  fi
}

setup_alacritty() {
  alacrittyPath=($HOME/AppData/Roaming/alacritty $HOME/.config/alacritty $HOME/.config/alacritty)
  util_print alacritty

  util_backUpConfig ${alacrittyPath[$osIndex]}
  mkdir -p ${alacrittyPath[$osIndex]}
  # util_makeSymlinkPath $HOME/dotfiles/alacritty ${alacrittyPath[$osIndex]}
  util_makeSymlinkPath $HOME/dotfiles/alacritty/alacritty.$os.yml ${alacrittyPath[$osIndex]}/alacritty.yml

  if [[ "$os" == "windows" ]]; then
    $getter install -y alacritty
  fi
}

setup_node () {
  util_print nodejs
  # curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -

  if [[ "$os" == "windows" ]]; then
    # $getter install -y nodejs
    # choco install nvm
    $getter install -y nodejs-lts
  elif [[ "$os" == "linux" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install 14
  fi
}

install_various_apps() {
  util_print ripgrep
  $getter install -y ripgrep
  $getter install -y fd

  util_print wget
  $getter install -y wget

  util_print curl
  $getter install -y curl

  util_print python
  $getter install -y python
  # c:\python39\python.exe -m pip install --upgrade pip
  # pip install --user --upgrade pynvim
  # python -m pip install --upgrade Pillow
  # python -m pip install --upgrade mupdf

  util_print rust
  $getter install -y rust
  # cargo install --list
  # cargo install stylua vimv

  $getter install -y onefetch
  $getter install -y scrcpy

  # util_print taskwarrior
  # apt install taskwarrior
  # pip3 install tasklib
  # pip3 install six

  # util_print vit
  # pip3 install vit

  if [[ "$os" == "windows" ]]; then
    $getter install -y mingw
  elif [[ "$os" == "linux" ]]; then
    $getter install -y build-essential
    $getter install -y ninja-build
  fi
}

setup_keypirinha() {
  # install path C:\ProgramData\chocolatey\lib\keypirinha\tools\Keypirinha
  keypirinhaPath=($HOME/AppData/Roaming/Keypirinha)
  util_print keypirinha

  util_backUpConfig ${keypirinhaPath[$osIndex]}
  util_makeSymlinkPath $HOME/dotfiles/gui/Keypirinha ${keypirinhaPath[$osIndex]}
  $getter install -y keypirinha
}

setup_sublime() {
  util_print sublime
  rm -rf $HOME/AppData/Roaming/Sublime\ Text/Packages/User/
  util_makeSymlinkPath $HOME/dotfiles/gui/sublime_text "'C:\Users\hasan\AppData\Roaming\Sublime Text\Packages\User'"
}

setup_windowsTerminal() {
  util_print WinTerminal

  wtPath=($HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json)
  # wtPathBeta=($HOME/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json)
  $getter install -y microsoft-windows-terminal # --pre
  rm -rf ${wtPath[$osIndex]}
  util_makeSymlinkPath $HOME/dotfiles/windows-terminal/settings.json  ${wtPath[$osIndex]}

  # # $getter install -y microsoft-windows-terminal  # --pre
  # choco install -y microsoft-windows-terminal --version=1.11.3471.0 -y
  # rm -rf $HOME/AppData/Local/Microsoft/Windows\ Terminal/settings.json
  # util_makeSymlinkPath $HOME/dotfiles/windows-terminal/settings.json "'C:\Users\hasan\AppData\Local\Microsoft\Windows Terminal\settings.json'"
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
  printf 'source-file ~/dotfiles/tmux/.tmux.conf' >> ~/.tmux.conf

  echo 'Done'
}

auto_install_everything() {
  echo ' ** Auto Install ** '

  setup_git_defaults
  setup_bash
  setup_alacritty
  setup_nvim
  setup_lazygit
  # setup_tig
  setup_lf
  setup_wezterm
  setup_node
  install_various_apps

  if [[ "$os" == "windows" ]]; then
    start ms-settings:developers
    setup_windowsTerminal
    setup_keypirinha
    $getter install -y quicklook
    setup_sublime
  elif [[ "$os" == "linux" ]]; then
    install_and_setup_tmux
  fi
}

prompt_and_get_answers() {
  util_setup_figlet
  auto_install_everything

  util_print done.
}

prompt_and_get_answers

