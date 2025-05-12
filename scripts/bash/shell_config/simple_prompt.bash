#!/bin/bash
git-branch-name() {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
}

git-branch() {
  local branch
  branch=$(git-branch-name)
  if [ "$branch" ]; then printf "\033[0;33m %s " "$branch"; fi
}

set_win_title() {
  echo -ne "\033]0; "$PWD" \007"
}

re-prompt() {
  set_win_title
}

PROMPT_COMMAND=re-prompt

export PS1="\n\`if [ \$? = 0 ];then echo \[\e[35m\]; else echo \[\e[31m\];fi\`[\t∣\d] \[\e[36m\]\w \`git-branch\` \[\e[0m\]\n>> "
# export PS1="\n\`if [ \$? = 0 ];then echo \[\e[35m\]; else echo \[\e[31m\];fi\`[\t∣\d] \[\e[36m\]\w \[\e[0m\]\n>> "
