# shellcheck disable=SC1091

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

[ -f "$HOME/.env.local" ] && set -a && source "$HOME/.env.local" && set +a

source "$HOME/dotfiles/scripts/bash/shell_config/.env"
source "$HOME/dotfiles/scripts/bash/shell_config/.aliases"
source "$HOME/dotfiles/scripts/bash/shell_config/glob-alias.sh"
source "$HOME/dotfiles/scripts/bash/shell_config/fzf.sh"
source "$HOME/dotfiles/scripts/bash/shell_config/functions.bash"
source "$HOME/dotfiles/scripts/bash/shell_config/simple_prompt.bash"
source "$HOME/dotfiles/scripts/bash/shell_config/vim.bash"
source "$HOME/dotfiles/scripts/bash/shell_config/zoxide.bash"
