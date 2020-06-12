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

tpope/vim-fugitive
Another must have by Tim Pope. Fugitive is a plugin that allows you to work with
git in Vim. You can execute basically any git command in Vim. In my daily usage,
I use only a few commands though:

:Gread
It is the same to git checkout [file].

:Gwrite
It is the same to git add [file].

:Gdiff
It opens a vim-diff with the buffer changes relative to the HEAD.

:Gblame
To blame your coworker.

:Ggrep
In file project-wide search. It’s faster than vimgrep. I use it over fzf’s Ag
when I want to populate a quickfix list and work on this list.
