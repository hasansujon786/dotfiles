# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -f ~/dotfiles/bash/.env ]; then
  source ~/dotfiles/bash/.fzf.sh
  source ~/dotfiles/bash/.aliases.bash
  source ~/dotfiles/bash/vim.bash
  source ~/dotfiles/bash/.env
  source ~/dotfiles/bash/simple_prompt.bash
  source ~/dotfiles/bash/zoxide.bash
fi
