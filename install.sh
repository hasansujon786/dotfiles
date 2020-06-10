#!/bin/bash
##!/bin/sh

set -e

echo "      _       _         __ _ _"
echo "   __| | ___ | |_      / _(_) | ___  ___"
echo "  / _\` |/ _ \| __|____| |_| | |/ _ \/ __|"
echo " | (_| | (_) | ||_____|  _| | |  __/\__ \\"
echo "  \__,_|\___/ \__|    |_| |_|_|\___||___/"
echo ""


# if [ -f ~/mydotfiles/bash/.bashrc ]; then
#  . ~/mydotfiles/bash/.bashrc
# fi

# global variable
pkgm='pkg'


mkSpace() {
  echo ' '
}

setup_bash() {
  echo 'Configuring base profile...'
  mkSpace

  if [ -f ~/.bashrc ]; then
    echo 'Removing old .bashrc'
    rm ~/.bashrc
  fi

  echo 'Creating .bashrc'
  printf 'if [ -f ~/mydotfiles/bash/.bashrc ]; then\n . ~/mydotfiles/bash/.bashrc\nfi' >> ~/.bashrc

  echo 'done'
  mkSpace
}

setup_git_defaults() {
  git config --global user.email "hasansujon786@gmail.com"
  git config --global user.name "Hasan Mahmud"
  git config --global credential.helper store

  # git config --global credential.helper 'cache --timeout=86400'
  # git credential-cache exit
}

install_and_setup_tmux() {
  echo 'Instlling tmux...'
  $pkgm install tmux
  mkSpace

  if [ -f ~/.tmux.conf ]; then
    echo 'Removing old .tmux.conf'
    rm ~/.tmux.conf
  fi

  echo 'Creating .tmux.conf'
  printf 'source-file ~/mydotfiles/tmux/.tmux.conf \nbind r source-file ~/.tmux.conf' >> ~/.tmux.conf

  echo 'done'
  mkSpace
}

install_and_setup_nvim() {
  echo 'Installing Neovim...'
  $pkgm install neovim
  mkSpace

  if [ -d ~/.config ]; then
    echo 'Removing old .config directory.'
    rm -rf ~/.config
  fi

  echo 'Creating .config/nvim/init.vim.'
  mkdir ~/.config/nvim -p
  mkdir ~/.config/nvim/tmp -p
  mkdir ~/.config/nvim/tmp/backup -p
  mkdir ~/.config/nvim/tmp/swap -p
  mkdir ~/.config/nvim/tmp/undo -p
  touch ~/.config/nvim/init.vim
  printf 'if !empty(glob("~/mydotfiles/nvim/init.vim"))\n  source ~/mydotfiles/nvim/mod.dorin.vim\n  echo "Welcom to Neovim" \nendif' >> ~/.config/nvim/init.vim

  echo 'Installing vim-plug.'
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'done'
  mkSpace

  echo "==> Here we go..."
  echo "  > Installing vim plugins..."
  nvim +PlugInstall +qall

  echo "==> Done with setup."
}


auto_install_everything() {
  echo ' ** Auto Install ** '

  setup_bash
  setup_git_defaults
  install_and_setup_tmux
  install_and_setup_nvim
}

prompt_and_get_answers() {
  echo '(1) Auto install.'
  echo '(2) Manual install.'
  echo '>> Select any option.'
  read isAutoInstall
  mkSpace

  echo ">> Type the pkg manager you're using.."
  read pkgName
  pkgm=$pkgName
  mkSpace

  if [ $isAutoInstall -eq 1 ]
  then auto_install_everything
  else manual_install
  fi
}

prompt_and_get_answers
#setup_git_defaults

