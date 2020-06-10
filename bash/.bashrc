# Copy this to main .bashrc file
#if [ -f ~/mydotfiles/bash/.bashrc ]; then
#    . ~/mydotfiles/bash/.bashrc
#fi

# alias name=value
# alias name='command'
# alias name='command arg1 arg2'
# alias name='/path/to/script'
# alias name='/path/to/script.pl arg1'

# Default
# PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ '
# Use on Pc
#PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\][\T] \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ '
#  Use on phone
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\[\033[32m\]Hasan@i50 \[\033[35m\][\T] \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ '

# Load mappings
source ~/mydotfiles/bash/.aliases
