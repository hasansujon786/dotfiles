#!/bin/bash
# Yarn
alias yup='yarn upgrade-interactive --latest'
alias ycc='yarn cache clean'
alias ya='yarn android'
alias ys='yarn start'
alias yd='yarn dev'
alias si='zi && sc'
alias sc='~/dotfiles/scripts/sc.sh'
# npm
alias no="NODE_OPTIONS='--inspect'"
alias nri='node --inspect '
alias ns='npm start'
alias nsc="npm start --reset-cache"
alias nd='npm run dev'
alias ncc='npm cache clean --force'
alias esint='npm init @eslint/config'
# expo
alias esc='npx expo start --clear'
# tsc
alias tsw='tsc -w'
alias tsi='tsc --init'

# Vim
alias v.='nvim .'
alias vi='zi && nvim'
alias ni='zi && nvim'
alias vim=nvim
alias v=nvim
alias lv=vl
alias vl='nvim -c "normal '\''0"'
alias vll='nvim -c "SessionLoad"'
alias vst='nvim --startuptime startup.log -c exit && tail -100 startup.log'
alias cd.='cd ~/dotfiles && nvim'
alias nvr='nvim --listen "127.0.0.1:6666"'
alias ch='start chrome --restore-last-session --remote-debugging-port=9222' # --args
# alias ch='/c/Program\ Files/Google/Chrome/Application/chrome.exe --restore-last-session --remote-debugging-port=9222'

# Tmux
alias t="tmux new -As pasta"
alias tt="tmux new -s "
alias ta="tmux attach"
# alias tmux="env TERM=xterm-256color tmux"

# Windows Terminal
# alias wt="c:\\\Program\ Files\\\WindowsApps\\\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\\\wt.exe"
alias wtt='wt -w 0 nt -d .'
alias dx='pwsh -Command dxdiag'
alias su='subl'
alias sub='subl'
subl() {
	"C:\Program Files\Sublime Text\subl.exe" "$@"
}

# Android
alias grc='./gradlew clean'
alias bure='./gradlew bundleRelease'
alias asre='./gradlew assembleRelease'
alias asde='./gradlew assembleDebug'
alias emd='~/AppData/Local/Android/Sdk/emulator/emulator -avd default_device -netdelay none -netspeed full'

# React native
alias rndoc='npx @react-native-community/cli doctor'

# Flutter
alias flr='flutter run'
alias flrp='flutter run -d "$MY_PHONE_IP"'
alias fll='flutter clean'
alias flc='flutter create'
alias flcs='flutter create -t skeleton'
alias fob='cd build/app/outputs/flutter-apk && explorer .'
alias dp='dart pub'
alias dbb='dart run build_runner build --delete-conflicting-outputs'
alias dbw='dart run build_runner watch --delete-conflicting-outputs'
alias dpum='dart pub upgrade --major-versions'

#adb
alias adk='adb kill-server'
alias add='adb devices'
alias adu='adb uninstall'
alias ada='adb disconnect'
alias adlp='adb shell pm list packages' # adb shell pm list packages -f -3

alias adi='~/dotfiles/scripts/adb_install.sh'
alias acc='~/dotfiles/scripts/ld.sh "adb connect"'
alias acd='~/dotfiles/scripts/ld.sh "adb disconnect"'
alias arr='~/dotfiles/scripts/adb_wifi.sh'
alias scc='~/dotfiles/scripts/ld.sh "scrcpy -b 2M -s"'
alias scr='scrcpy -d'

# handy short cuts #
alias bashrc="vim ~/dotfiles/bash/.bashrc"
alias keyp='C:/Users/hasan/dotfiles/scripts/keypirinha.sh'
alias -- -='cd -'
alias ..='cd ..'
alias cs='cd'
alias re='cd /e/repoes'
alias to='touch'
alias mk='mkdir -p'
mm() { mkdir -p "$@" && cd "$@" || exit; }
alias x='exit'
alias e='z'
alias c='clear && pwd && ls'
# alias c='clear'
alias live='live-server'
alias h='history'
alias o='explorer'
alias open='explorer'
alias dus='du -h --max-depth=1 --exclude=node_modules* | sort -rh'
alias dua='du -s * --exclude=node_modules* | sort -rn | cut -f2- | xargs -d "\n" du -sh'
alias lf='lfcd'
# Copy the PWD to the Clipboard
alias cpd="pwd | tr -d '\n' | clip && echo 'pwd copied to clipboard'"
# alias cpwd="pwd | tr -d '\n' | pbcopy && echo 'pwd copied to clipboard'"
alias y='yazi_cd'
alias yazi='yazi_cd'
function yazi_cd() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	\yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Better copy
function cpy {
	while read -r data; do              # reads data piped in to cpy
		echo "$data" | cat >/dev/clipboard # echos the data and writes that to /dev/clipboard
	done
	tr -d '\n' </dev/clipboard >/dev/clipboard # removes new lines from the clipboard
}

# git
alias ggpusht='git push origin $(git_current_branch) --tags'
alias ggpushf='git push origin $(git_current_branch) --force'
alias ggpushtf='git push origin $(git_current_branch) --tags --force'
alias ggpushft='git push origin $(git_current_branch) --tags --force'
alias ggpull='git pull --rebase origin $(git_current_branch)'
alias ggpp='git pull --rebase origin $(git_current_branch) && git push origin $(git_current_branch)'
alias gg='git graph'
alias gstp='git stash push -m'
alias grget='git remote get-url origin'
alias gpr='hub pull-request'
alias gci='hub issue create'
alias gm2m='git branch -m master main'
alias gpup='git push --set-upstream origin main'

alias -- --=jump-to-git-root
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gs='git show'
alias gd='git diff'
alias gt='git tag'
alias gst='git status'
alias gupd='git update'
alias gcl='git clone --recurse-submodules'
alias gb='git branch --sort=-committerdate | fzf --border-label="Checkout Recent Branch" --preview "git diff {1} --color=always" | xargs git checkout'
alias gbn='git checkout -b' # create & switch branch
alias gck='git checkout'    # switch brnch
# Use --soft if you want to keep your changes
# Use --hard if you don't care about keeping the changes you made
alias gr='git reset '        # unstage files (Use --hard/--soft)
alias grh='git reset HEAD~1' # (Use --hard/--soft)
alias grvh='git revert HEAD' # Undo a public commit
alias gcrh='git clean --force && git reset --hard'
alias grlc='git reset --soft HEAD^'
alias glo='git log --oneline --decorate'
alias gme='git merge'
alias gms='git merge --squash'
alias grbi='git rebase --interactive main'
alias lg='lazygit'
alias gsd='pwd | xargs git config --global --add safe.directory'

# kill port
alias fp='tasklist | findstr' # search string
alias tk='taskkill //F //IM'
alias tkp='taskkill //PID'
alias tkv='taskkill //F //IM "java.exe"'

# alias ls='ls --color=auto' # Colorize the ls output
# alias ll='ls -la --color=auto' # Use a long listing format
# alias lsa='ls -a --color=auto' # Show all files
# alias ls.='ls -d .* --color=auto' # Show only hidden files
alias ls='eza'                          # Colorize the ls output
alias ll='eza -lah --sort type --icons' # Use a long listing format
alias tree='eza --tree'                 # Use a long listing format

# handy date shortcuts #
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# unix
alias le='less -j4'
alias chex='chmod +x'
alias cpr='cp -r'
# alias rr='rm -rfI'
# alias rm='trash'
alias rr='remove'
alias mn='mv -vn'
alias txf='tar -xf'
alias uz='unzip'
alias uzl='unzip -l'
alias fN='find . -name "*'
alias ff='find . -name "*.'
alias h='hash -rf'
alias sz='source ~/.zshrc'
alias sb='source ~/.bashrc'
alias hx='hexdump -C'
alias k9='kill -9'
alias k15='kill -s 15'
alias w1='watch -n 1'

jump-to-git-root() {
	local _root_dir _pwd

	_root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [[ $_root_dir == "" ]]; then
		>&2 echo 'Not a Git repo!'
		return 0
	fi
	_pwd=$(pwd -W)
	if [[ $_pwd = "$_root_dir" ]]; then
		# Handle submodules:
		# If parent dir is also managed under Git then we are in a submodule.
		# If so, cd to nearest Git parent project.
		if ! _root_dir="$(git -C "$(dirname "$_pwd")" rev-parse --show-toplevel 2>/dev/null)"; then
			echo "Already at Git repo root."
			return 0
		fi
	fi
	# Make `cd -` work.
	OLDPWD=$_pwd
	echo "Git repo root: $_root_dir"
	cd "$_root_dir" || exit
}
lfcd() {
	tmp="$(mktemp)"
	\lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		if [ -d "$dir" ]; then
			if [ "$dir" != "$(pwd)" ]; then
				cd "$dir" || exit
			fi
		fi
	fi
}
remove() {
	while true; do
		local count=$#
		if [[ $count = 0 ]]; then
			echo "rm: missing argument"
			return
		fi
		local item='item'
		[[ $count -gt 1 ]] && item="items"

		read -r -p "trash: Do you wish to remove ${count} ${item} (y/n)? " yn
		case $yn in
		# [Yy]* ) rm -rf $@; break;;
		[Yy]*)
			trash "$@"
			break
			;;
		[Nn]*)
			echo "rm: Canceled"
			break
			;;
		*) echo "rm: Please answer yes or no." ;;
		esac
	done
}
_edit_wo_executing() {
	local editor="${EDITOR:-vim}"
	tmpf="$(mktemp)"
	printf '%s\n' "$READLINE_LINE" >"$tmpf"
	"$editor" "$tmpf"
	READLINE_LINE="$(<"$tmpf")"
	READLINE_POINT="${#READLINE_LINE}"
	rm -f "$tmpf" # -f for those who have alias rm='rm -i'
}
url-redrive() {
	curl --silent -I -L "$@" | grep -i location
}

# auto-expand
bind '"\e\ ":magic-space'
bind '"\eq":alias-expand-line'
bind '" ":"\eq\C-v "'

bind '"\eo":"\C-uyazi_cd\C-m"'
# bind '"\el":clear-screen'
# bind '"\C-x\C-x":edit-and-execute-command'
# bind -x '"\C-x\C-e":_edit_wo_executing'
