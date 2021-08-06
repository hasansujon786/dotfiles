""""""""""""""""""""""""""
" handle too large files
""""""""""""""""""""""""""
 file is larger than 10mb
 let g:LargeFile = 1024 * 1024 * 10
 augroup LargeFile
   au!
   autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
 augroup END

 function! LargeFile()
  " no syntax highlighting etc
  setlocal eventignore+=FileType
  " no wrap
  setlocal nowrap
  " no spell check
  setlocal nospell
  " no hidden character rendering
  setlocal nolist
  " disable signcolumn
  setlocal signcolumn=no
  " disable colorcolumn
  setlocal colorcolumn=
  " save memory when other file is viewed
  setlocal bufhidden=unload
  " is read-only (write with :w new_filename)
  setlocal buftype=nowrite
  " no undo possible
  setlocal undolevels=-1

  let b:airline_disable_statusline = 1

  " display message
  autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
 endfunction


