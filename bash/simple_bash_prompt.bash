# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

function set_win_title(){
  echo -ne "\033]0; $(basename "$PWD") \007"
}

git-branch-name() {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
}

git-branch() {
  local YELLOW="\033[0;33m"
  local branch=`git-branch-name`
  if [ $branch ]; then printf "\[${YELLOW}\] %s " $branch; fi
}

re-prompt() {
  set_win_title
  local PINK="\033[35m"
  local BLUE="\033[0;36m"
  local NOCOLOR="\033[0m"
  local HEAD=""

  PS1="\n\[${PINK}\][\T∣\d] \[${BLUE}\]\w $(git-branch)\n\`if [ \$? = 0 ]; then echo \[\e[0m\]\[${HEAD}\]; else echo \[\e[31m\]\[${HEAD}\]; fi\`\[${NOCOLOR}\] "
}

if [ "$color_prompt" = yes ]; then
  PROMPT_COMMAND=re-prompt
fi
unset color_prompt

