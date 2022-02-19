# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

git-branch-name() {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
}

dir-and-git-branch() {
  local branch=`git-branch-name`
  printf "\[\033[0;36m\]\w "
  if [ $branch ]; then printf "\[\033[1;33m\] %s " $branch; fi
}

re-prompt() {
  PS1="\n\[\033[35m\][\T∣\d] $(dir-and-git-branch)\n \`if [ \$? = 0 ]; then echo \[\e[0m\]; else echo \[\e[31m\]; fi\`\[\033[0m\] "
}

if [ "$color_prompt" = yes ]; then
  PROMPT_COMMAND=re-prompt
fi
unset color_prompt

