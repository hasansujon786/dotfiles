#!/bin/bash
# fd --type f --hidden --exclude .git | fzf | xargs nvim
#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ key-bindings.bash
#
# - $FZF_TMUX_OPTS
# - $FZF_CTRL_T_COMMAND
# - $FZF_CTRL_T_OPTS
# - $FZF_CTRL_R_OPTS
# - $FZF_ALT_C_COMMAND
# - $FZF_ALT_C_OPTS

# Key bindings
# ------------
__fzf_z__() {
	[ $# -gt 0 ] && z "$*" && return
	local cmd dir
	cmd="zoxide query -i -- $1"
	dir=$(eval "$cmd") && printf 'cd -- %q' "$dir"
}

__fzf_z_plus__() {
	[ $# -gt 0 ] && z "$*" && return
	local out key dir
	IFS=$'\n' out=("$(zoxide query -l | fzf --query="$1" --exit-0 --expect=alt-o,ctrl-e,alt-e --border-label='Zoxide')")
	key=$(head -1 <<<"$out")
	dir=$(head -2 <<<"$out" | tail -1)

	if [ -n "$dir" ]; then
		if [[ "$key" = alt-o ]]; then
			if [ -f "$dir/package.json" ]; then
				term_cmd="wezterm cli spawn --cwd \"$dir\""
				id=$(eval "$term_cmd")
				echo "yarn dev" | wezterm cli send-text --pane-id "$id"
			fi
			printf 'cd -- %q && nvim' "$dir"
			# wt -w 0 nt -d $dir -p "Bash" C:\\Program Files\\Git\\bin\\bash -c "yarn start"
			# cd $dir && nvim
		elif [[ "$key" = ctrl-e ]]; then
			printf 'explorer %q' "$dir"
		elif [[ "$key" = alt-e ]]; then
			printf 'cd -- %q && lfcd' "$dir"
		else
			printf 'cd -- %q' "$dir"
		fi
	fi
}

# ALT-e - cd into the selected directory
bind -m emacs-standard '"\ee": " \C-b\C-k \C-u`__fzf_z_plus__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d\C-h"'

__fzf_select__() {
	local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
	eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read -r item; do
		printf '%q ' "$item"
	done
	echo
}

if [[ $- =~ i ]]; then

	__fzfcmd() {
		[[ -n "$TMUX_PANE" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "$FZF_TMUX_OPTS" ]]; } &&
			echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
	}

	fzf-file-widget() {
		local selected
		selected="$(__fzf_select__)"
		READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
		READLINE_POINT=$((READLINE_POINT + ${#selected}))
	}

	__fzf_cd__() {
		local cmd dir
		cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
		dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m) && printf 'cd -- %q' "$dir"
	}

	__fzf_history__() {
		local output
		output=$(
			builtin fc -lnr -2147483648 |
				last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e 'BEGIN { getc; $/ = "\n\t"; $HISTCMD = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCMD - $. . "\t$_" if !$seen{$_}++' |
				FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m --read0" $(__fzfcmd) --query "$READLINE_LINE"
		) || return
		READLINE_LINE=${output#*$'\t'}
		if [[ -z "$READLINE_POINT" ]]; then
			echo "$READLINE_LINE"
		else
			READLINE_POINT=0x7fffffff
		fi
	}

	# Required to refresh the prompt after fzf
	bind -m emacs-standard '"\er": redraw-current-line'

	bind -m vi-command '"\C-z": emacs-editing-mode'
	bind -m vi-insert '"\C-z": emacs-editing-mode'
	bind -m emacs-standard '"\C-z": vi-editing-mode'

	if ((BASH_VERSINFO[0] < 4)); then
		# CTRL-T - Paste the selected file path into the command line
		bind -m emacs-standard '"\C-t": " \C-b\C-k \C-u`__fzf_select__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f"'
		bind -m vi-command '"\C-t": "\C-z\C-t\C-z"'
		bind -m vi-insert '"\C-t": "\C-z\C-t\C-z"'

		# CTRL-R - Paste the selected command from history into the command line
		bind -m emacs-standard '"\C-r": "\C-e \C-u\C-y\ey\C-u"$(__fzf_history__)"\e\C-e\er"'
		bind -m vi-command '"\C-r": "\C-z\C-r\C-z"'
		bind -m vi-insert '"\C-r": "\C-z\C-r\C-z"'
	else
		# CTRL-T - Paste the selected file path into the command line
		bind -m emacs-standard -x '"\C-t": fzf-file-widget'
		bind -m vi-command -x '"\C-t": fzf-file-widget'
		bind -m vi-insert -x '"\C-t": fzf-file-widget'

		# CTRL-R - Paste the selected command from history into the command line
		bind -m emacs-standard -x '"\C-r": __fzf_history__'
		bind -m vi-command -x '"\C-r": __fzf_history__'
		bind -m vi-insert -x '"\C-r": __fzf_history__'
	fi

	# ALT-C - cd into the selected directory
	bind -m emacs-standard '"\ec": " \C-l\C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
	bind -m vi-command '"\ec": "\C-l\C-z\ec\C-z"'
	bind -m vi-insert '"\ec": "\C-l\C-z\ec\C-z"'

fi

fk() {
	local pid
	pid=$(tasklist | sed 1d | fzf -m | awk '{print $1}')

	if [ "x$pid" != "x" ]; then
		echo "$pid" | xargs taskkill //F //IM
	fi
}

fo() {
	readarray -t out <<<"$(fzf --query="$1" --exit-0 --expect=alt-o,ctrl-e)"
	shortcut=${out[0]}
	files=("${out[@]:1}")

	if [[ "$shortcut" = alt-o ]]; then
		if [[ "${#files[@]}" -gt 1 ]]; then
			for file in "${files[@]}"; do
				explorer "$file"
			done
		elif [[ "${#files[@]}" -eq 1 ]]; then
			explorer "${files[0]}"
		fi
	else
		# ${EDITOR:-nvim} "$files"
		nvim "${files[@]}"
	fi
}

fn() {
	local files
	if [ ! "$#" -gt 0 ]; then
		echo "Need a string to search for!"
		return 1
	fi
	files=$(rg --files-with-matches --no-messages --smart-case "$1" | fzf --reverse --multi --preview "cat {}")
	if [ -n "$files" ]; then
		nvim "$files"
	fi
}

b() {
	# bookmarks_path="c/AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Bookmarks"
	bookmarks_path="$HOME/AppData/Local/BraveSoftware/Brave-Browser/User Data/Default/Bookmarks"

	jq_script="
  def ancestors: while(. | length >= 2; del(.[-1,-2]));
  . as \$in | paths(.url?) as \$key | \$in | getpath(\$key) | {name,url, path: [\$key[0:-2] | ancestors as \$a | \$in | getpath(\$a) | .name?] | reverse | join(\"/\") } | .path + \"/\" + .name + \"\t\" + .url"

	jq -r "$jq_script" <"$bookmarks_path" |
		sed -E $'s/(.*)\t(.*)/\\1\t\x1b[36m\\2\x1b[m/g' |
		fzf --ansi |
		cut -d$'\t' -f2 |
		xargs start
}

emo() {
	fzf </c/Users/hasan/dotfiles/bash/emojis.txt | sed 's/ .*//'
}

em() {
	# ~/AppData/Local/Android/Sdk/emulator/emulator
	emulator -list-avds |
		fzf --height=10 |
		xargs emulator -netdelay none -netspeed full -avd
}
