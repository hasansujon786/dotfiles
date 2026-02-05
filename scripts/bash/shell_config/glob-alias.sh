# auto-expand
bind -m emacs-standard -x '" ":expand_aliases'
bind -m vi-command -x '" ":expand_aliases'
bind -m vi-insert -x '" ":expand_aliases'
bind '"\C-@":magic-space'
# bind '"\e\ ":magic-space'
# bind '"\eq":alias-expand-line'
# bind '" ":"\eq\C-v "'

declare -A EXCLUDE_EXPAND_ALIASES=(
  ["ls"]=1
  ["cat"]=1
  ["cd"]=1
  ["git"]=1
  ["e"]=1
  ["z"]=1
  ["--"]=1
)
insert_space() {
  # Simulate pressing Space by inserting a space at the current cursor position
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT} ${READLINE_LINE:$READLINE_POINT}"
  ((READLINE_POINT++))
}
expand_aliases() {
  # Exit if cursor is not at the end
  if [ "$READLINE_POINT" -ne "${#READLINE_LINE}" ]; then
    insert_space
    return
  fi

  local input="$READLINE_LINE"
  local -a words=($input) # Split into words (using whitespace as delimiter)
  local word_count=${#words[@]}

  # Exit if input is empty or has space at the end or word_count isn't 1
  if [[ -z $input || $input =~ [[:space:]]$ || $word_count -eq 0 || $word_count -gt 1 ]]; then
    insert_space
    return
  fi

  # Get the last word (or empty if none)
  local last_word="${words[-1]:-}"
  # Exit if last_word is empty or matched with exclude values
  if [[ -z $last_word || -n "${EXCLUDE_EXPAND_ALIASES[$last_word]}" ]]; then
    insert_space
    return
  fi

  if [[ $last_word =~ ^[[:space:]]*([a-zA-Z0-9_-]+)(.*)$ ]]; then
    local cmd=${BASH_REMATCH[1]}

    # Look up the alias definition
    if builtin alias $cmd >/dev/null 2>&1; then
      local found_alias=$(builtin alias $cmd 2>/dev/null)

      if [[ -n $found_alias && $found_alias =~ =\'(.*)\' ]]; then
        cmd="${BASH_REMATCH[1]}"
        # replace the alias with its definition
        READLINE_LINE="$cmd "
        READLINE_POINT=${#READLINE_LINE}
        return
      fi
    fi
  fi

  insert_space
}
