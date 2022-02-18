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

git-branch-name() {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
}

dir-and-git-branch() {
  local branch=`git-branch-name`
  if [ $branch ]; then printf "\[\033[0;36m\]…/\W "; else printf "\[\033[0;36m\]\w "; fi
  if [ $branch ]; then printf "\[\033[1;33m\] %s " $branch; fi
}

re-prompt() {
  PS1="\[\033[35m\][\T∣\d] $(dir-and-git-branch)\n \`if [ \$? = 0 ]; then echo \[\e[0m\]; else echo \[\e[31m\]; fi\`\[\033[0m\] "
}

if [ "$color_prompt" = yes ]; then
  PROMPT_COMMAND=re-prompt
fi
unset color_prompt

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -f ~/dotfiles/bash/z.sh ] && source ~/dotfiles/bash/z.sh
[ -f ~/dotfiles/bash/.fzf.sh ] && source ~/dotfiles/bash/.fzf.sh
[ -f ~/dotfiles/bash/.aliases.bash ] && source ~/dotfiles/bash/.aliases.bash
[ -f ~/dotfiles/bash/.env ] && source ~/dotfiles/bash/.env

