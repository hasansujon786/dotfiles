#!/bin/bash
# https://superuser.com/questions/1601543/ctrl-x-e-without-executing-command-immediately
_edit_wo_executing() {
	local editor="${EDITOR:-nano}"
	tmpf="$(mktemp)"
	printf '%s\n' "$READLINE_LINE" >"$tmpf"
	"$editor" "$tmpf"
	READLINE_LINE="$(<"$tmpf")"
	READLINE_POINT="$(printf '%s' "$READLINE_LINE" | wc -c)" # READLINE_POINT="${#READLINE_LINE}"
	rm -f "$tmpf"                                            # -f for those who have alias rm='rm -i'
}

# bind -x '"\C-x\C-e":_edit_wo_executing'
# bind to "C-x e" in all modes
bind -m vi -x '"\C-x\C-e":_edit_wo_executing'
bind -m vi-insert -x '"\C-x\C-e":_edit_wo_executing'
bind -m emacs -x '"\C-x\C-e":_edit_wo_executing'

# Neovim config swithcer
alias lz="NVIM_APPNAME=LazyVim nvim"
alias vi="NVIM_APPNAME=LazyVim nvim"
# alias nvim-kick="NVIM_APPNAME=kickstart nvim"
# alias nvim-chad="NVIM_APPNAME=NvChad nvim"
# alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"
bind -x '"\C-a": nvims'

function nvims() {
	items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
	config=$(printf "%s\n" "${items[@]}" | fzf --border-label=' Neovim Config' --height=~50% --layout=reverse --border --exit-0)
	if [[ -z $config ]]; then
		echo "Nothing selected"
		return 0
	elif [[ $config == "default" ]]; then
		config=""
	else
		alias vi="NVIM_APPNAME=${NVIM_APPNAME:-${config}} nvim"
	fi
	NVIM_APPNAME=$config nvim "$@"
}
