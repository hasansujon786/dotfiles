#!/bin/bash
##!/bin/sh

set -e

echo "      _       _         __ _ _"
echo "   __| | ___ | |_      / _(_) | ___  ___"
echo "  / _\` |/ _ \| __|____| |_| | |/ _ \/ __|"
echo " | (_| | (_) | ||_____|  _| | |  __/\__ \\"
echo "  \__,_|\___/ \__|    |_| |_|_|\___||___/"
echo ""

mkSpace() {
  echo ' '
}


setup_git_defaults() {
  toilet --font mono12 git
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
  toilet --font mono12 bash
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
  toilet --font mono12 tmux
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
  toilet --font mono12 nvim
  # L => "~/.config/nvim/init.vim"
  echo 'Installing Neovim...'
  apt install -y neovim

  if [ -d ~/.config ]; then
    echo 'Removing old .config directory.'
    rm -Rf ~/.config
  fi

  echo 'Creating .config/nvim/init.vim.'
  mkdir ~/.config/nvim -p
  mkdir ~/.config/nvim/tmp -p
  mkdir ~/.config/nvim/tmp/backup -p
  mkdir ~/.config/nvim/tmp/swap -p
  mkdir ~/.config/nvim/tmp/undo -p
  touch ~/.config/nvim/init.vim
  printf 'if !empty(glob("~/dotfiles/nvim/mod.dorin.vim"))\n  source ~/dotfiles/nvim/mod.dorin.vim \nendif' >> ~/.config/nvim/init.vim

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
  toilet --font mono12 nodejs
  apt install -y nodejs

  toilet --font mono12 ripgrep
  apt install -y ripgrep

  toilet --font mono12 tig
  apt install -y tig

  toilet --font mono12 wget
  apt install -y wget

  toilet --font mono12 python
  apt install -y python
  python3 -m pip install --user --upgrade pynvim
  # TODO:
  # npm install --global live-server


  toilet --font mono12 lazygit
  # NOTE: Currently lazygit installation only worls for termux
  # TODO: Support for Linux & Windows
  export LAZYGIT_VER="0.20.9"
  # wget -O lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz
  wget -O lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_arm64.tar.gz
  tar xvf lazygit.tgz
  # sudo mv lazygit /usr/local/bin/
  mv lazygit /data/data/com.termux/files/usr/bin/lazygit
  rm lazygit.tgz

}

auto_install_everything() {
  echo ' ** Auto Install ** '

  setup_bash
  install_and_setup_tmux
  install_and_setup_nvim
  install_various_apps
}

prompt_and_get_answers() {
  setup_git_defaults
  apt upgrade && apt update 
  apt install -y toilet
  auto_install_everything

  # if [ $isAutoInstall -eq 1 ]
  # then auto_install_everything
  # else manual_install
  # fi
}

prompt_and_get_answers

