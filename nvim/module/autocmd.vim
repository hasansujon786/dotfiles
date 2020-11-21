augroup vimrcEx
  autocmd!
  " Load all plugins
  if !exists('g:all_plugged_loaded')
    execute 'autocmd CursorHold,CursorHoldI * BootPlug' | let g:all_plugged_loaded = 1
  endif

  " Vertically center document when entering insert mode
  autocmd InsertEnter * norm zz
  " Vim/tmux layout rebalancing
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =
  " Trim white spaces before saving
  autocmd BufWritePre *.vim :call hasan#autocmd#trimWhitespace()
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG' |
        \   exe "normal g`\"" |
        \ endif

  " automatically zoom window on focus
  autocmd WinEnter * if exists('g:auto_zoom_window') | call hasan#utils#azw() | endif

  " Custom fzf statusline
  autocmd User FzfStatusLine call hasan#autocmd#fzf_statusline()

  " Neovim terminal
  autocmd TermOpen * setfiletype terminal | set bufhidden=hide
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

augroup FernEvents
  autocmd!
  autocmd FileType fern call hasan#fern#FernInit()
  autocmd FileType fern call glyph_palette#apply()
  autocmd BufEnter * ++nested call hasan#boot#hijack_directory()
  " autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

" Create file-marks for commonly edited file types
augroup FileMarks
  autocmd!
  autocmd BufLeave *.html normal! mH
  autocmd BufLeave *.js   normal! mJ
  autocmd BufLeave *.ts   normal! mT
  autocmd BufLeave *.vim  normal! mV
	autocmd BufLeave *.css  normal! mC
  autocmd BufLeave *.txt  normal! mK
augroup END

