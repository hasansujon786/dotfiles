https://phoenixnap.com/kb/change-bash-prompt-linux

# bind '\C-o:clear-screen'
# bind '"\eh":"foobar"'
# bind '"\e[24~":"foobar"'
# bind '"\ed":kill-word'

git-branch-name() {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

project_dir () {
  git_parent=`dirname $(git rev-parse --show-toplevel 2>/dev/null)`
  printf `pwd -W | sed -E -e "s|$git_parent|…|"`
  sub_terr=$(git rev-parse --show-prefix)
  # if [ $branch ]; then printf "\[\033[0;36m\]%s " $(project_dir); else printf "\[\033[0;36m\]\w "; fi
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
  if [ $git_modified_symbol ]; then printf "%s " $git_modified_symbol; fi
}


globalias() {
  echo "foo"
   # Get last word to the left of the cursor:
   # (z) splits into words using shell parsing
   # (A) makes it an array even if there's only one element
   # local word=${${(Az)LBUFFER}[-1]}
   # if [[ $GLOBALIAS_FILTER_VALUES[(Ie)$word] -eq 0 ]]; then
      # zle _expand_alias
      # zle expand-word
   # fi
   # zle self-insert
}
# zle -N globalias
bind '"\001":"echo command"'
# bind '"\002":"echo command"'
bind '\C-\ :clear-screen'
bind -x '"\el":globalias'
# space expands all aliases, including global
# bindkey -M emacs " " globalias
# bindkey -M viins " " globalias

# # control-space to make a normal space
# bindkey -M emacs "^ " magic-space
# bindkey -M viins "^ " magic-space

# # normal space during searches
# bindkey -M isearch " " magic-space

open_alacritty() {
  start alacritty --working-directory $(pwd)
  # nohup alacritty --working-directory $(pwd) </dev/null &>/dev/null &
}

open_bash() {
  start bash
}

-- "$SECONDS"
