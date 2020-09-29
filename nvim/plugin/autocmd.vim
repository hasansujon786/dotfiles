augroup vimrcEx
  autocmd!
  if !exists('g:all_plugged_loaded')
    execute 'autocmd CursorHold,CursorHoldI * BootPlug' | let g:all_plugged_loaded = 1
  endif
  " Vertically center document when entering insert mode
  autocmd InsertEnter * norm zz

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Vim/tmux layout rebalancing
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

  " automatically zoom window on focus
  autocmd WinEnter * if exists('g:auto_zoom_window') | call hasan#utils#azw() | endif
  autocmd BufWritePre *.vim :call hasan#autocmd#trimWhitespace()
augroup END

augroup CursorLine
  au!
  " Only show the cursor line in the active buffer.
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
  au WinEnter,BufWinEnter * call hasan#boot#auto_set_cursor_color()

  " Highlight the textwidth column.
  au WinEnter,BufWinEnter *.vim,*.js call hasan#boot#highligt_textwith_column(1)
        \| au WinLeave,BufWinLeave,BufLeave <buffer> call hasan#boot#highligt_textwith_column(0)
augroup END

" Neovim terminal
if has('nvim')
  augroup Terminal
    au!
    au TermOpen * setfiletype terminal | set bufhidden=hide | :startinsert
    au BufEnter * if &buftype == 'terminal' | :startinsert | endif
    au FileType terminal setlocal nonumber norelativenumber signcolumn=no
  augroup END
endif

