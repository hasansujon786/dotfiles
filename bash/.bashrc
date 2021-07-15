# alias name=value
# alias name='command'
# alias name='command arg1 arg2'
# alias name='/path/to/script'
# alias name='/path/to/script.pl arg1'

# Default Prompt
# PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ '
# Use on Pc
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\][\T] \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ '
#  Use on phone
# PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\[\033[32m\]Hasan@4x \[\033[35m\][\T] \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ '


[ -f ~/dotfiles/bash/.aliases ] && source ~/dotfiles/bash/.aliases
[ -f ~/dotfiles/bash/.env ] && source ~/dotfiles/bash/.env

open_alacritty() {
  start alacritty --working-directory $(pwd)
  # nohup alacritty --working-directory $(pwd) </dev/null &>/dev/null &
}

open_bash() {
  start bash
}

# bindkey -s '^t' 'open_alacritty\o'  # CTRL-T in terminal calls for open_alacritty function
bind -x '"\C-t\C-t":"open_alacritty"'
bind -x '"\C-tq":"open_bash"'
