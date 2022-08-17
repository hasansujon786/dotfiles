# tmux resources

### Pair programming in tmux
- https://github.com/livingsocial/ls-pair
### Everything you need to know about tmux statusbar
- https://arcolinux.com/everything-you-need-to-know-about-tmux-status-bar/
### tmux command references
- https://hyperpolyglot.org/multiplexers
### Get host & current user name in tmux statusbar
- https://github.com/soyuka/tmux-current-pane-hostname
### Various shortcuts
- https://gist.github.com/MohamedAlaa/2961058

# tmux variables
- Date: %m/%d/%y | %A, %d %b %Y
- Time: %I:%M:%p

> " Ctrl-@                 0x00            NUL
> " Ctrl-A to Ctrl-Z       0x01 to 0x1A
> " Ctrl-a to Ctrl-z       0x01 to 0x1A
> " Ctrl-[                 0x1B            ESC
> " Ctrl-\                 0x1C
> " Ctrl-]                 0x1D
> " Ctrl-^                 0x1E
> " Ctrl-_                 0x1F
> " Ctrl-?                 0x7F            DEL

" https://learnvimscriptthehardway.stevelosh.com/chapters/21.html
" https://medium.com/breathe-publication/understanding-vims-jump-list-7e1bfc72cdf0
> https://vimways.org/2019/

sudo vim /etc/hostname

# cmp
https://github.com/hrsh7th/nvim-cmp/issues/231

# vim-surround
vim.cmd[[ let b:surround_{char2nr('F')} = "function()\n return \r\nend" ]]

# winbar
https://github.com/max397574/omega-nvim/blob/a3fcd501805105494fb5231c035e9181a5aaf50a/lua/omega/core/settings/init.lua#L67
