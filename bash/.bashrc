# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
  PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\][\T] \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ '
fi
unset color_prompt

[ -f ~/dotfiles/bash/.aliases.bash ] && source ~/dotfiles/bash/.aliases.bash
[ -f ~/dotfiles/bash/.env ] && source ~/dotfiles/bash/.env
[ -f ~/dotfiles/bash/z.sh ] && source ~/dotfiles/bash/z.sh
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function set_win_title(){
  echo -ne "\033]0; $(basename "$PWD") \007"
}
starship_precmd_user_func="set_win_title"
export STARSHIP_CONFIG=~/dotfiles/bash/starship.toml
eval "$(starship init bash)"
