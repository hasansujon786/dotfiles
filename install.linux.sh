#!/bin/bash
##!/bin/sh

set -e

echo "      _       _         __ _ _"
echo "   __| | ___ | |_      / _(_) | ___  ___"
echo "  / _\` |/ _ \| __|____| |_| | |/ _ \/ __|"
echo " | (_| | (_) | ||_____|  _| | |  __/\__ \\"
echo "  \__,_|\___/ \__|    |_| |_|_|\___||___/"
echo ""

# configs
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     machine=linux;;
  Darwin*)    machine=mac;;
  CYGWIN*)    machine=windows;;
  MINGW*)     machine=windows;;
    *)        machine="UNKNOWN:${unameOut}"
esac
echo \ ${machine}

case "${machine}" in
  linux*)     getter=apt;;
  windows*)   getter=choco;;
    *)        getter=hello
esac

# utils
mkSpace() {
  echo ' '
}
printWithFiglet() {
  figlet \ $1
}

setup_git_defaults() {
  printWithFiglet git
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
  printWithFiglet bash
  # L => ~/.bashrc
  echo 'Configuring base profile...'

  if [ -f ~/.bashrc ]; then
    echo 'Removing old .bashrc.'
    rm ~/.bashrc
  fi

  echo 'Creating new .bashrc.'
  printf 'if [ -f ~/dotfiles/bash/.bashrc ]; then\n . ~/dotfiles/bash/.bashrc\nfi' >> ~/.bashrc

  echo 'Done...'
  mkSpace
}


install_and_setup_tmux() {
  # Only linux (tmux is not working on win, reason: unknown)
  # L => ~/.tmux.conf
  printWithFiglet tmux
  echo 'Instlling tmux...'
  apt install -y tmux
  mkSpace

  if [ -f ~/.tmux.conf ]; then
    echo 'Removing old .tmux.conf'
    rm ~/.tmux.conf
  fi

  echo 'Creating .tmux.conf'
  printf 'source-file ~/dotfiles/tmux/.tmux.conf' >> ~/.tmux.conf

  echo 'Done'
  mkSpace
}


install_and_setup_nvim() {
  printWithFiglet nvim
  # L => "~/.config/nvim/init.vim"
  echo 'Installing Neovim...'
  apt install -y neovim

  if [ -d ~/.config/nvim ]; then
    echo 'Removing old .config directory.'
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y.%m.%d-%H:%M:%S)"
  fi

  mkdir -p ~/.config
  ln -s ~/dotfiles/nvim ~/.config/nvim
  ln -s ~/storage/shared/documents/vimwiki ~/vimwiki

  echo 'Installing vim-plug.'
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'Done..'
  mkSpace

  echo "Installing vim plugins..."
  nvim +PlugInstall +qall

  echo "Done with setup."
}


install_various_apps() {
  printWithFiglet nodejs
  apt install -y nodejs

  printWithFiglet ripgrep
  apt install -y ripgrep

  printWithFiglet tig
  apt install -y tig
  ln -s ~/dotfiles/tui/tig/.tigrc ~/.tigrc

  printWithFiglet lf
  apt install -y lf
  ln -s ~/dotfiles/tui/lf ~/.config/lf
  curl https://raw.githubusercontent.com/thameera/vimv/master/vimv > /data/data/com.termux/files/usr/bin/vimv && chmod +755 /data/data/com.termux/files/usr/bin/vimv
  # curl https://raw.githubusercontent.com/thameera/vimv/master/vimv > ~/bin/vimv && chmod +755 ~/bin/vimv

  printWithFiglet wget
  apt install -y wget

  printWithFiglet python
  apt install -y python
  python3 -m pip install --user --upgrade pynvim
  # @todo:
  # npm install --global live-server


  printWithFiglet lazygit
  # NOTE: Currently lazygit installation only worls for termux
  # @todo: Support for Linux & Windows
  mkdir -p ./lazy
  export LAZYGIT_VER="0.28.1"
  # wget -O lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz
  wget -O ./lazy/lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_arm64.tar.gz
  tar xvf ./lazy/lazygit.tgz -C ./lazy/
  # sudo mv lazygit /usr/local/bin/
  mv ./lazy/lazygit /data/data/com.termux/files/usr/bin/lazygit
  rm -rf ./lazy

  if [ -d ~/.config/jesseduffield ]; then
    echo 'Removing old lazygit config.'
    rm -rf ~/.config/jesseduffield
  fi

  mkdir -p ~/.config/jesseduffield/lazygit
  ln -s ~/dotfiles/tui/lazygit/config.yml ~/.config/jesseduffield/lazygit/config.yml

  printWithFiglet taskwarrior
  apt install taskwarrior
  pip3 install tasklib
  pip3 install six

  printWithFiglet vit
  pip3 install vit
}

auto_install_everything() {
  echo ' ** Auto Install ** '

  setup_bash
  install_and_setup_tmux
  install_and_setup_nvim
  install_various_apps
}

prompt_and_get_answers() {
  if [[ $getter=="choco" ]]; then
    $getter install -y figlet-go
  else
    apt upgrade && apt update 
    $getter install -y toilet
  fi

  setup_git_defaults
  auto_install_everything

  printWithFiglet done.
}

# prompt_and_get_answers

# setup_git_defaults
# setup_bash
