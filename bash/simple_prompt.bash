#!/bin/bash
git-branch-name() {
	git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
}

git-branch() {
	local branch=$(git-branch-name)
	if [ "$branch" ]; then printf "\033[0;33m %s " "$branch"; fi
}

export PS1="\n\`if [ \$? = 0 ];then echo \[\e[35m\]; else echo \[\e[31m\];fi\`[\t∣\d] \[\e[36m\]\w \`git-branch\` \[\e[0m\]\n>> "
