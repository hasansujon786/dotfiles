augroup vimrcEx
  autocmd!
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

augroup Focus
  au!
  " Only show the cursor line in the active buffer.
  au WinEnter,BufWinEnter,FocusGained * setlocal cursorline
  au WinLeave,FocusLost * setlocal nocursorline
  au WinEnter,BufWinEnter * call hasan#boot#auto_set_cursor_color()

  " Highlight the textwidth column.
  au WinEnter,BufWinEnter *.vim,*.js call hasan#boot#highligt_textwith_column(1)
        \| au WinLeave,BufWinLeave,BufLeave <buffer> call hasan#boot#highligt_textwith_column(0)

  " Change active/inactive window background
  au FocusGained,WinEnter,BufWinEnter * call hasan#focus#focus_window()
  au FocusLost * call hasan#focus#blur_this_window()

  " Goyo Events
  au User GoyoEnter nested call hasan#goyo#goyo_enter()
  au User GoyoLeave nested call hasan#goyo#goyo_leave()

  if has_key(environ(), 'TMUX')
    autocmd VimEnter,VimResume,FocusGained * call system('tmux set status off')
    autocmd VimLeave,VimSuspend,FocusLost * call system('tmux set status on')
  endif
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

" Load all plugins
function! BootAllPlugins(...) abort
  BootPlug
  let g:all_plug_loaded = 1

  " Lazy load nerdfont
  try | let g:nerdfont_loaded = g:nerdfont#default == '' ? 1 : 0
  catch | let g:nerdfont_loaded = 0 | endtry
endfunction

augroup LazyLoadPlug
  autocmd!
  autocmd CursorHold,CursorHoldI * call BootAllPlugins() | autocmd! LazyLoadPlug
augroup end
