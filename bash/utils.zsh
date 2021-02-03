function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}

zle -N fg-bg
bindkey '^z' fg-bg
bindkey '^x^x' edit-command-line

# mkdir and cd in one command
mcd() {
  mkdir -p -- "$1" &&
    cd -P -- "$1" || return
}

fog() { ${EDITOR:-vim} $(rg -n '.*' "$HOME/Documents/org" | fzf --prompt "fnote> " --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g'); }
# notegrep() { ${EDITOR:-vi} -c "NGrep $*"; }
# command! -nargs=0 NGrep grep! ".*" ~/Documents/org/**/*.org

# Calculator
# calc() { echo "scale=5;$*" | bc -l; }

