# https://superuser.com/questions/1601543/ctrl-x-e-without-executing-command-immediately
_edit_wo_executing() {
    local editor="${EDITOR:-nano}"
    tmpf="$(mktemp)"
    printf '%s\n' "$READLINE_LINE" > "$tmpf"
    "$editor" "$tmpf"
    READLINE_LINE="$(<"$tmpf")"
    READLINE_POINT="$(printf '%s' "$READLINE_LINE" | wc -c)"      # READLINE_POINT="${#READLINE_LINE}"
    rm -f "$tmpf"  # -f for those who have alias rm='rm -i'
}

# bind -x '"\C-x\C-e":_edit_wo_executing'
# bind to "C-x e" in all modes
bind -m vi        -x '"\C-x\C-e":_edit_wo_executing'
bind -m vi-insert -x '"\C-x\C-e":_edit_wo_executing'
bind -m emacs     -x '"\C-x\C-e":_edit_wo_executing'
