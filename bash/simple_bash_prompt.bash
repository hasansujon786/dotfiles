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

git_status() {
  local RED="\033[0;31m"
  local GREEN="\033[0;32m"
  local NOCOLOR="\033[0m"
  local YELLOW="\033[0;33m"
  local BLACK="\033[0;30m"

  local git_modified_symbol=""
  local git_status=$(git status 2>/dev/null | grep "Your branch is ahead" 2>/dev/null)
  if [ "$git_status" != "" ]; then git_modified_symbol="\[${YELLOW}\][!]"; fi

  local git_status=$(git status --porcelain 2>/dev/null)
  if [ "$git_status" != "" ]; then git_modified_symbol="\[${RED}\][?]"; fi
  if [ $git_modified_symbol ]; then echo $git_modified_symbol; fi
}

git-branch() {
  local YELLOW="\033[0;33m"
  local branch=`git-branch-name`
  if [ $branch ]; then printf "\[${YELLOW}\] %s %s" $branch `git_status`; fi
}

re-prompt() {
  set_win_title
  local PINK="\033[35m"
  local BLUE="\033[0;36m"
  local NOCOLOR="\033[0m"

  PS1="\n\[${PINK}\][\T∣\d] \[${BLUE}\]\w $(git-branch)\n \`if [ \$? = 0 ]; then echo \[\e[0m\]; else echo \[\e[31m\]; fi\`\[${NOCOLOR}\] "
}

if [ "$color_prompt" = yes ]; then
  PROMPT_COMMAND=re-prompt
fi
unset color_prompt

