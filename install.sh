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
util_print() {
  echo ' '
  figlet \ $1
}
util_setup_figlet() {
  if [[ "$machine" == "windows" ]]; then
    $getter install -y figlet-go
  else
    apt upgrade && apt update 
    $getter install -y figlet
  fi
}
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


###### setup functions ######
setup_git_defaults() {
  util_print git

  echo ">> Type your github username."
  read git_user_name
  echo ">> Type your github email."
  read git_user_email

  git config --global user.email $git_user_email
  git config --global user.name $git_user_name
  git config --global credential.helper store

  # git config --global credential.helper 'cache --timeout=86400'
  # git credential-cache exit
}

setup_bash() {
  bashPath=(~/.bashrc ~/.bashrc ~/.bashrc)
  util_print bash

  util_backUpConfig ${bashPath[$machineCode]}
  util_makeSymlinkPath ~/dotfiles/bash/.bashrc ${bashPath[$machineCode]}
}

setup_nvim() {
  nvimPath=(~/AppData/Local/nvim ~/.config/nvim ~/.config/nvim)
  util_print nvim

  util_backUpConfig ${nvimPath[$machineCode]}
  util_makeSymlinkPath ~/dotfiles/nvim ${nvimPath[$machineCode]}

  $getter install -y neovim

  packerPath=(~/AppData/Local/nvim-data/site/pack/packer/start/packer.nvim, ~/.local/share/nvim/site/pack/packer/start/packer.nvim)
  git clone https://github.com/wbthomason/packer.nvim ${packerPath[$machineCode]}
  # echo "Installing vim plugins..."
  # nvim +PlugInstall +qall
}

setup_lazygit () {
  lazygitPath=(~/AppData/Roaming/lazygit ~/.config/lazygit ~/.config/lazygit)
  util_print lazygit

  util_backUpConfig ${lazygitPath[$machineCode]}
  util_makeSymlinkPath ~/dotfiles/tui/lazygit ${lazygitPath[$machineCode]}

  # $getter install -y lazygit

  # install manually
  # # NOTE: Currently lazygit installation only worls for termux
  # mkdir -p ./lazy
  # export LAZYGIT_VER="0.28.1"
  # # wget -O lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz
  # wget -O ./lazy/lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_arm64.tar.gz
  # tar xvf ./lazy/lazygit.tgz -C ./lazy/
  # # sudo mv lazygit /usr/local/bin/
  # mv ./lazy/lazygit /data/data/com.termux/files/usr/bin/lazygit
  # rm -rf ./lazy
}

setup_lf() {
  lfPath=(~/AppData/Local/lf ~/.config/lf ~/.config/lf)
  util_print lf

  util_backUpConfig ${lfPath[$machineCode]}
  util_makeSymlinkPath ~/dotfiles/tui/lf ${lfPath[$machineCode]}
  $getter install -y lf

  # TODO: add vimb support to lf
  # curl https://raw.githubusercontent.com/thameera/vimv/master/vimv > /data/data/com.termux/files/usr/bin/vimv && chmod +755 /data/data/com.termux/files/usr/bin/vimv
  # curl https://raw.githubusercontent.com/thameera/vimv/master/vimv > ~/bin/vimv && chmod +755 ~/bin/vimv
}

setup_alacritty() {
  alacrittyPath=(~/AppData/Roaming/alacritty ~/.config/alacritty ~/.config/alacritty)
  util_print alacritty

  util_backUpConfig ${alacrittyPath[$machineCode]}
  util_makeSymlinkPath ~/dotfiles/alacritty ${alacrittyPath[$machineCode]}
  $getter install -y alacritty
}

install_various_apps() {
  util_print nodejs
  $getter install -y nodejs
  # https://www.codegrepper.com/code-examples/shell/install+nodejs+in+elementary+os

  util_print ripgrep
  $getter install -y ripgrep

  # TODO
  # util_print tig
  # $getter install -y tig
  # ln -s ~/dotfiles/tui/tig/.tigrc ~/.tigrc

  util_print wget
  $getter install -y wget

  util_print python
  $getter install -y python
# c:\python39\python.exe -m pip install --upgrade pip
  # pip install --user --upgrade pynvim
  # @todo:
  # npm install --global live-server

  # TODO
  # util_print taskwarrior
  # apt install taskwarrior
  # pip3 install tasklib
  # pip3 install six

  # util_print vit
  # pip3 install vit
}

setup_keypirinha() {
  # install path C:\ProgramData\chocolatey\lib\keypirinha\tools\Keypirinha
  keypirinhaPath=(~/AppData/Roaming/Keypirinha)
  util_print keypirinha

  util_backUpConfig ${keypirinhaPath[$machineCode]}
  util_makeSymlinkPath ~/dotfiles/gui/Keypirinha ${keypirinhaPath[$machineCode]}
  $getter install -y keypirinha
}

install_and_setup_tmux() {
  # TODO: (tmux is not working on win, reason: unknown)
  # L => ~/.tmux.conf
  util_print tmux
  echo 'Instlling tmux...'
  apt install -y tmux

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
  # setup_lazygit
  # setup_lf
  install_various_apps

  if [ $machineCode -eq 0 ]; then
    setup_keypirinha
  fi
}

prompt_and_get_answers() {
  util_setup_figlet
  auto_install_everything

  util_print done.
}

# prompt_and_get_answers

# util_makeSymlinkPath D:\\repoes\\plugins\\kissline.nvim  C:\\Users\\hasan\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\kissline.nvim
# util_makeSymlinkPath D:\\repoes\\plugins\\notifier.nvim  C:\\Users\\hasan\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\notifier.nvim
# util_makeSymlinkPath D:\\repoes\\plugins\\telescope-yanklist.nvim  C:\\Users\\hasan\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-yanklist.nvim
