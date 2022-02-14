# Yarn
alias yup='yarn upgrade-interactive --latest'
alias ycc='yarn cache clean'
alias ya='yarn android'
alias ys='yarn start'
alias yd='yarn dev'
# npm
alias ns='npm start'
alias nd='npm run dev'
alias ncc='npm cache clean --force'

# Vim
alias v.='nvim .'
alias vim=nvim
alias v=nvim
alias lv=vl
alias vl='nvim -c "normal '\''0"'
alias vst='nvim --startuptime startup.log -c exit && tail -100 startup.log'
alias cd.='cd ~/dotfiles && nvim'
alias cdk='cd ~/AppData/Local/nvim-data/site/pack/packer/opt/kissline.nvim && nvim'

# Tmux
alias t="tmux new -As pasta"
alias tt="tmux new -s "
alias ta="tmux attach"
# alias tmux="env TERM=xterm-256color tmux"

# Windows Terminal
alias wt="c:\\\Program\ Files\\\WindowsApps\\\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\\\wt.exe"
alias wtt='wt -w 0 nt -d .'
alias rgb='wt -w 0 nt -p PowerShell powershell -c rgb-tui'

# React native
alias grc="./gradlew clean"
alias grrc="cd android && ./gradlew clean && cd .."
alias bure='cd android && ./gradlew bundleRelease'
alias asre='cd android && ./gradlew assembleRelease'
alias asde='cd android && ./gradlew assembleDebug'
alias inre='react-native run-android --variant=release'

# Flutter
alias flr='flutter run'
alias flc='flutter clean'

#adb
alias acc='adb connect 192.168.31.252'
alias add='adb devices'
alias adres='adb kill-server && adb devices'
alias scc='scrcpy -s 192.168.31.252 --always-on-top'
alias scc2='scrcpy -s f8a8aa489804 --always-on-top'

# handy short cuts #
alias bashrc="vim ~/dotfiles/bash/.bashrc"
alias -- -='cd -'
alias ..='cd ..'
alias cs='cd'
alias re='cd /e/repoes'
alias to='touch'
alias mk='mkdir -p'
alias x='exit'
alias e='z'
alias c='clear && pwd && ls'
# alias c='clear'
alias h='history'
alias o='explorer'
alias open='explorer'
alias du='du -h --max-depth=0 '
# Copy the PWD to the Clipboard
alias cpd="pwd | tr -d '\n' | clip && echo 'pwd copied to clipboard'"
# alias cpwd="pwd | tr -d '\n' | pbcopy && echo 'pwd copied to clipboard'"

# Better copy
function cpy {
  while read data; do     # reads data piped in to cpy
    echo "$data" | cat > /dev/clipboard     # echos the data and writes that to /dev/clipboard
  done
  tr -d '\n' < /dev/clipboard > /dev/clipboard     # removes new lines from the clipboard
}

# git
alias ggpusht='git push origin $(git_current_branch) --tags'
alias ggpushf='git push origin $(git_current_branch) --force'
alias ggpushtf='git push origin $(git_current_branch) --tags --force'
alias ggpushft='git push origin $(git_current_branch) --tags --force'
alias ggpull='git pull --rebase origin $(git_current_branch)'
alias ggpp='git pull --rebase origin $(git_current_branch) && git push origin $(git_current_branch)'
alias gg='git graph'
alias gsts='git stash save'
alias grget='git remote get-url origin'
alias gpr='hub pull-request'
alias gci='hub issue create'

alias -- --=jump-to-git-root
alias g='git'
alias gs='git show'
alias gt='git tag'
alias gst='git status'
alias gupd='git update'
alias gcl='git clone --recurse-submodules'
alias grh='git reset HEAD~1' # --hard
alias gr='git reset ' # --hard
alias gck='git checkout ' # switch brnch | -b to create
alias glo='git log --oneline --decorate'
alias lg='lazygit'

# termux
alias ex='cd ~/storage/external-1'

# kill port
alias fipid='netstat -ano | findstr'
alias kipid='taskkill /PID'

## Colorize the ls output ##
alias ls='ls --color=auto'
alias lsa='ls -a'
## Use a long listing format ##
alias ll='ls -la'
## Show hidden files ##
alias l.='ls -d .* --color=auto'

# handy date shortcuts #
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

if test -n "$ZSH_VERSION"; then
  bindkey '^o' clear-screen
else
  bind '" ":"\e\C-e\C-v '
  bind '"\el":clear-screen'
  # bind '"\el":shell-expand-line'
  # bind '\C-o:clear-screen'
  # bind '"\eh":"foobar"'
  # bind '"\e[24~":"foobar"'
  # bind '"\ed":kill-word'
fi

# unix
alias le='less -j4'
alias chex='chmod +x'
alias cpr='cp -r'
alias rr='rm -rfI'
alias mn='mv -vn'
alias txf='tar -xf'
alias uz='unzip'
alias uzl='unzip -l'
alias fn='find . -name "*'
alias ff='find . -name "*.'
alias h='hash -rf'
alias sz='source ~/.zshrc'
alias sb='source ~/.bashrc'
alias hx='hexdump -C'
alias k9='kill -9'
alias k15='kill -s 15'
alias w1='watch -n 1'


open_alacritty() {
  start alacritty --working-directory $(pwd)
  # nohup alacritty --working-directory $(pwd) </dev/null &>/dev/null &
}

open_bash() {
  start bash
}

jump-to-git-root() {
  local _root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ $_root_dir == "" ]]; then
    >&2 echo 'Not a Git repo!'
    return 0
  fi
  local _pwd=$(pwd -W)
  if [[ $_pwd = $_root_dir ]]; then
    # Handle submodules:
    # If parent dir is also managed under Git then we are in a submodule.
    # If so, cd to nearest Git parent project.
    _root_dir="$(git -C $(dirname $_pwd) rev-parse --show-toplevel 2>/dev/null)"
    if [[ $? -gt 0 ]]; then
      echo "Already at Git repo root."
      return 0
    fi
  fi
  # Make `cd -` work.
  OLDPWD=$_pwd
  echo "Git repo root: $_root_dir"
  cd $_root_dir
}


# bindkey -s '^t' 'open_alacritty\o'  # CTRL-T in terminal calls for open_alacritty function
# windows
# bind -x '"\C-t\C-t":"open_alacritty"'
# bind -x '"\C-tq":"open_bash"'

