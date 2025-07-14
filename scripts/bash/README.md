# Usefull links
https://phoenixnap.com/kb/change-bash-prompt-linux

# Coor Codes
```bash
blk='\[\033[01;30m\]'   # Black
red='\[\033[01;31m\]'   # Red
grn='\[\033[01;32m\]'   # Green
ylw='\[\033[01;33m\]'   # Yellow
blu='\[\033[01;34m\]'   # Blue
pur='\[\033[01;35m\]'   # Purple
cyn='\[\033[01;36m\]'   # Cyan
wht='\[\033[01;37m\]'   # White
clr='\[\033[00m\]'      # Reset
```

# Poor man fetch
```bash
printf "\n"
printf "   %s\n" "IP ADDR: $(curl ifconfig.me)"
printf "   %s\n" "USER: $(echo $USER)"
printf "   %s\n" "DATE: $(date)"
printf "   %s\n" "UPTIME: $(uptime -p)"
printf "   %s\n" "HOSTNAME: $(hostname -f)"
printf "   %s\n" "CPU: $(awk -F: '/model name/{print $2}' | head -1)"
printf "   %s\n" "KERNEL: $(uname -rms)"
printf "   %s\n" "PACKAGES: $(dpkg --get-selections | wc -l)"
printf "   %s\n" "RESOLUTION: $(xrandr | awk '/\*/{printf $1" "}')"
printf "   %s\n" "MEMORY: $(free -m -h | awk '/Mem/{print $3"/"$2}')"
printf "\n"
```


# vim mode in bash
```bash
set -o vi
bind '"jk":vi-movement-mode'

# SET THE MODE STRING AND CURSOR TO INDICATE THE VIM MODE
#   FOR THE NUMBER AFTER `\e[`:
#     0: blinking block
#     1: blinking block (default)
#     2: steady block
#     3: blinking underline
#     4: steady underline
#     5: blinking bar (xterm)
#     6: steady bar (xterm)
#     Ex: \e[5 q\ , \e[1 q\
# set vi-ins-mode-string "\1\e[1;32me[0m\2>> "
# set vi-cmd-mode-string "\1\e[1;32me[0m\2:: "
```

# Keymap syntax
```bash
bind '\C-o:clear-screen'
bind '"\eh":"foobar"'
bind '"\e[24~":"foobar"'
bind '"\ed":kill-word'
```

# Usefull functions
```bash

echo "$SECONDS"
git-branch-name() {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
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

sourceIfExists() {
  if [ -e $1 ]; then
    source $1;
  fi
}
sourceIfExists ~/dotfiles/bash/.aliases




# ```
