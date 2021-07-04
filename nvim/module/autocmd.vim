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
        \ if exists('g:all_plug_loaded') && &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG' |
        \   exe "normal g`\"" |
        \ endif

  " Neovim terminal
  autocmd TermOpen * setfiletype terminal | set bufhidden=hide
  autocmd ColorScheme * call hasan#highlight#load_custom_highlight()
  autocmd BufWritePost plugins.lua PackerCompile
  autocmd FocusGained * :checktime " Check if we need to reload the file when it changed
" cmd("au TextYankPost * lua vim.highlight.on_yank {}")
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

  " Goyo Events
  au User GoyoEnter nested call hasan#goyo#goyo_enter()
  au User GoyoLeave nested call hasan#goyo#goyo_leave()
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
  " BootPlug
  let g:all_plug_loaded = 1

  " Lazy load nerdfont
  try | let g:nerdfont_loaded = g:nerdfont#default == '' ? 1 : 0
  catch | let g:nerdfont_loaded = 0 | endtry
  " source $HOME/dotfiles/nvim/config/lazy/index.vim
  runtime! autoload/netrw.vim
endfunction

augroup LazyLoadPlug
  autocmd!
  autocmd VimEnter * ++once call timer_start(300, 'BootAllPlugins')
augroup end
