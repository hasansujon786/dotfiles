#!/bin/bash
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

if [[ $- =~ i ]]; then

  # Key bindings
  # ------------

  __fzf_defaults() {
    # $1: Prepend to FZF_DEFAULT_OPTS_FILE and FZF_DEFAULT_OPTS
    # $2: Append to FZF_DEFAULT_OPTS_FILE and FZF_DEFAULT_OPTS
    echo "--height ${FZF_TMUX_HEIGHT:-40%} --min-height 20+ --bind=ctrl-z:ignore $1"
    command cat "${FZF_DEFAULT_OPTS_FILE-}" 2>/dev/null
    echo "${FZF_DEFAULT_OPTS-} $2"
  }

  __fzf_select__() {
    FZF_DEFAULT_COMMAND=${FZF_CTRL_T_COMMAND:-} \
      FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=file,dir,follow,hidden --scheme=path" "${FZF_CTRL_T_OPTS-} -m") \
      FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "$@" |
      while read -r item; do
        printf '%q ' "$item" # escape special chars
      done
  }

  __fzfcmd() {
    [[ -n "${TMUX_PANE-}" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "${FZF_TMUX_OPTS-}" ]]; } &&
      echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
  }

  fzf-file-widget() {
    local selected="$(__fzf_select__ "$@")"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$((READLINE_POINT + ${#selected}))
  }

  __fzf_cd__() {
    local dir
    dir=$(
      FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
        FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
        FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd)
    ) && printf 'builtin cd -- %q' "$(builtin unset CDPATH && builtin cd -- "$dir" && builtin pwd)"
  }

  if command -v perl >/dev/null; then
    __fzf_history__() {
      local output script
      script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; s/\n/\n\t/gm; print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
      output=$(
        set +o pipefail
        builtin fc -lnr -2147483648 |
          last_hist=$(HISTTIMEFORMAT='' builtin history 1) command perl -n -l0 -e "$script" |
          FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --wrap-sign '"$'\t'"↳ ' --highlight-line ${FZF_CTRL_R_OPTS-} +m --read0") \
          FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) --query "$READLINE_LINE"
      ) || return
      READLINE_LINE=$(command perl -pe 's/^\d*\t//' <<<"$output")
      if [[ -z "$READLINE_POINT" ]]; then
        echo "$READLINE_LINE"
      else
        READLINE_POINT=0x7fffffff
      fi
    }
  else # awk - fallback for POSIX systems
    __fzf_history__() {
      local output script n x y z d
      if [[ -z $__fzf_awk ]]; then
        __fzf_awk=awk
        # choose the faster mawk if: it's installed && build date >= 20230322 && version >= 1.3.4
        IFS=' .' read n x y z d <<<$(command mawk -W version 2>/dev/null)
        [[ $n == mawk ]] && ((d >= 20230302 && (x * 1000 + y) * 1000 + z >= 1003004)) && __fzf_awk=mawk
      fi
      [[ $(HISTTIMEFORMAT='' builtin history 1) =~ [[:digit:]]+ ]] # how many history entries
      script='function P(b) { ++n; sub(/^[ *]/, "", b); if (!seen[b]++) { printf "%d\t%s%c", '$((BASH_REMATCH + 1))' - n, b, 0 } }
    NR==1 { b = substr($0, 2); next }
    /^\t/ { P(b); b = substr($0, 2); next }
    { b = b RS $0 }
    END { if (NR) P(b) }'
      output=$(
        set +o pipefail
        builtin fc -lnr -2147483648 2>/dev/null | # ( $'\t '<lines>$'\n' )* ; <lines> ::= [^\n]* ( $'\n'<lines> )*
          command $__fzf_awk "$script" |          # ( <counter>$'\t'<lines>$'\000' )*
          FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --wrap-sign '"$'\t'"↳ ' --highlight-line ${FZF_CTRL_R_OPTS-} +m --read0") \
          FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) --query "$READLINE_LINE"
      ) || return
      READLINE_LINE=${output#*$'\t'}
      if [[ -z "$READLINE_POINT" ]]; then
        echo "$READLINE_LINE"
      else
        READLINE_POINT=0x7fffffff
      fi
    }
  fi

  # Required to refresh the prompt after fzf
  bind -m emacs-standard '"\er": redraw-current-line'

  bind -m vi-command '"\C-z": emacs-editing-mode'
  bind -m vi-insert '"\C-z": emacs-editing-mode'
  bind -m emacs-standard '"\C-z": vi-editing-mode'

  if ((BASH_VERSINFO[0] < 4)); then
    # CTRL-T - Paste the selected file path into the command line
    if [[ "${FZF_CTRL_T_COMMAND-x}" != "" ]]; then
      bind -m emacs-standard '"\C-t": " \C-b\C-k \C-u`__fzf_select__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f"'
      bind -m vi-command '"\C-t": "\C-z\C-t\C-z"'
      bind -m vi-insert '"\C-t": "\C-z\C-t\C-z"'
    fi

    # CTRL-R - Paste the selected command from history into the command line
    bind -m emacs-standard '"\C-r": "\C-e \C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er"'
    bind -m vi-command '"\C-r": "\C-z\C-r\C-z"'
    bind -m vi-insert '"\C-r": "\C-z\C-r\C-z"'
  else
    # CTRL-T - Paste the selected file path into the command line
    if [[ "${FZF_CTRL_T_COMMAND-x}" != "" ]]; then
      bind -m emacs-standard -x '"\C-t": fzf-file-widget'
      bind -m vi-command -x '"\C-t": fzf-file-widget'
      bind -m vi-insert -x '"\C-t": fzf-file-widget'
    fi

    # CTRL-R - Paste the selected command from history into the command line
    bind -m emacs-standard -x '"\C-r": __fzf_history__'
    bind -m vi-command -x '"\C-r": __fzf_history__'
    bind -m vi-insert -x '"\C-r": __fzf_history__'
  fi

  # ALT-C - cd into the selected directory
  if [[ "${FZF_ALT_C_COMMAND-x}" != "" ]]; then
    bind -m emacs-standard '"\ec": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
    bind -m vi-command '"\ec": "\C-z\ec\C-z"'
    bind -m vi-insert '"\ec": "\C-z\ec\C-z"'
  fi
fi
### end: key-bindings.bash ###

# ------------------------------------------------
# -- Custom fzf funtions -------------------------
# ------------------------------------------------
# fd --type f --hidden --exclude .git | fzf | xargs nvim

__fzf_z__() {
  [ $# -gt 0 ] && z "$*" && return
  local cmd dir
  cmd="zoxide query -i -- $1"
  dir=$(eval "$cmd") && printf 'cd -- %q' "$dir"
}

__fzf_z_plus__() {
  readarray -t out <<<"$(zoxide query -l | fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-y,ctrl-e --border-label='Zoxide')"
  keybind=${out[0]}
  files=("${out[@]:1}")

  # Exit if no files are selected
  if [[ "${#files[@]}" -lt 1 ]]; then
    return
  fi
  local dir="${out[1]}"

  if [[ "$keybind" == "ctrl-o" ]]; then
    printf 'cd -- %q && nvim' "$dir"
  elif [[ "$keybind" == "ctrl-y" ]]; then
    printf 'cd -- %q && yazi' "$dir"
  elif [[ "$keybind" == "ctrl-e" ]]; then
    printf 'explorer %q' "$dir"
  # elif [[ "$keybind" == "alt-o" ]]; then
  #   if [ -f "$dir/package.json" ]; then
  #     term_cmd="wezterm cli spawn --cwd \"$dir\""
  #     id=$(eval "$term_cmd")
  #     echo "yarn dev" | wezterm cli send-text --pane-id "$id"
  #   fi
  #   printf 'cd -- %q && nvim' "$dir"
  #   # wt -w 0 nt -d $dir -p "Bash" C:\\Program Files\\Git\\bin\\bash -c "yarn start"
  #   # cd $dir && nvim
  else
    printf 'cd -- %q' "$dir"
  fi
}
bind -m emacs-standard '"\C-o": " \C-b\C-k \C-u`__fzf_z_plus__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d\C-h"'
bind -m vi-command '"\C-o": "\C-z\C-o\C-z"'
bind -m vi-insert '"\C-o": "\C-z\C-o\C-z"'

# Force kill selected tasks
fk() {
  local pid
  pid=$(tasklist | sed 1d | fzf -m | awk '{print $1}')

  if [ "x$pid" != "x" ]; then
    echo "$pid" | xargs taskkill //F //IM
  fi
}

# Search fiels in cwd & open nvim, yazi, explorer & more.
# default : Open each file with default app.
# ctrl-o  : Open each file with default app.
# ctrl-y  : Open yazi & focus on selected file.
# ctrl-e  : Open explorer & focus on selected file.
# alt-c   : Cd into directory of selected file.
f() {
  readarray -t out <<<"$(fzf --tac --query="$1" --expect=ctrl-o,alt-c,ctrl-y,ctrl-e)"
  keybind=${out[0]}
  files=("${out[@]:1}")

  # Exit if no files are selected
  if [[ "${#files[@]}" -lt 1 ]]; then
    return
  fi
  local first_file="${files[0]}"

  # Open text files with nvim if no kemaps are pressed
  if [[ "$keybind" == "ctrl-o" ]] || [ -z "$keybind" ]; then
    local mime_type
    local text_mime_types=("application/json" "application/javascript" "inode/x-empty" "application/xml" "application/x-sql" "application/octet-stream")
    mime_type=$(file --mime-type -b "$first_file")

    if [[ $mime_type == text/* ]] || [[ " ${text_mime_types[*]} " == *" $mime_type "* ]]; then
      ${EDITOR:-nvim} "${files[@]}"
      return
    fi
  fi

  # Cd into selected file directory
  if [[ "$keybind" == "alt-c" ]]; then
    dir=$(dirname "$first_file")
    cd "$dir" || exit && printf 'cd -- %q' "$dir"
  elif [[ "$keybind" == "ctrl-y" ]]; then
    yazi "$first_file"
  elif [[ "$keybind" == "ctrl-e" ]]; then
    local cwd filepath
    cwd=$(pwd -W | tr '/' '\\ ')
    filepath="${cwd}\\${first_file}"
    explorer /select,"$filepath"
  elif [[ "$keybind" == "ctrl-o" ]] || [ -z "$keybind" ]; then
    # Open each file with default app
    if [[ "${#files[@]}" -gt 1 ]]; then
      for cur_file in "${files[@]}"; do
        explorer "$cur_file"
      done
    else
      explorer "$first_file"
    fi
  fi
}

# Search string in cwd & open selected files in Neovim.
fn() {
  local search=""
  if [[ $# -gt 0 ]]; then
    search="$1"
    shift
  fi
  local files
  files=$(rg --color=always --line-number --no-heading --smart-case "$@" "$search" |
    fzf -d':' --ansi --multi \
      --preview "bat -p --color=always {1} --highlight-line {2}" \
      --preview-window "~8,+{2}-5")

  if [[ -z "$files" ]]; then
    echo "No file selected."
    return 1
  fi

  local vsplit_if_multiple=true # or false if you don't want vertical split
  local args=()

  while IFS= read -r line; do
    IFS=':' read -r filepath lineno _ <<<"${line//\\//}"
    if [[ "${#args[@]}" -eq 0 ]]; then
      # Open first file normally
      args+=("$filepath" "-c" "$lineno")
    else
      if [[ $vsplit_if_multiple == true ]]; then
        args+=("-c" "vsplit $filepath" "-c" "$lineno")
      else
        args+=("-c" "e $filepath" "-c" "$lineno")
      fi
    fi
  done <<<"$files"

  # Optionally equalize window sizes and go to first split
  if [[ $vsplit_if_multiple == true ]]; then
    args+=("-c" "wincmd =" "-c" "wincmd t")
  fi

  nvim "${args[@]}"
}

# Search & select files inside ~/my_vault/ and open it in Neovim.
fv() {
  local files
  files=$(rg --color=always --files "$HOME/my_vault/" |
    fzf --ansi --multi \
      --preview 'bat -p --color=always {}' \
      --preview-window '~8,+{2}-5')

  if [[ -z "$files" ]]; then
    echo "No file selected."
    return 1
  fi

  local vsplit_if_multiple=true # or false if you don't want vertical split
  local args=()

  while read -r filepath; do
    if [[ "${#args[@]}" -eq 0 ]]; then
      # Open first file normally
      args+=("$filepath")
    else
      if [[ $vsplit_if_multiple == true ]]; then
        args+=("-c" "vsplit $filepath")
      else
        args+=("-c" "e $filepath")
      fi
    fi
  done <<<"$files"

  # Optionally equalize window sizes and go to first split
  if [[ $vsplit_if_multiple == true ]]; then
    args+=("-c" "wincmd =" "-c" "wincmd t")
  fi

  args+=("-c" "normal! zv")

  nvim "${args[@]}"
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

eml() {
  # ~/AppData/Local/Android/Sdk/emulator/emulator
  emulator -list-avds |
    fzf --height=10 |
    xargs emulator -netdelay none -netspeed full -avd
}

re() {
  # TODO: use repo variable
  dir=$(fd --max-depth 2 --search-path /d/repoes | fzf)
  cd "$dir" || exit
}

scoop-uninstall() {
  local pkgs
  pkgs="$(scoop list | tail -n +5 | fzf --multi --border-label="Scoop Uninstall" | awk '{print $1}')"

  if [[ -z "$pkgs" ]]; then
    echo "No package selected. Aborting."
    return 1
  fi

  echo "Selected packages to uninstall:"
  echo "$pkgs"
  read -r -p "Scoop: Uninstall the selected packages (y/n)? " yn
  case $yn in
  [Yy]*)
    for pkg in $pkgs; do
      echo "Uninstalling $pkg..."
      scoop uninstall "$pkg"
    done
    ;;
  [Nn]*) echo "Canceled." ;;
  *) echo "Please answer yes or no." ;;
  esac
}
