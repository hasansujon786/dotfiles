
" AutoSetCursorColor {{{
function! hasan#boot#auto_set_cursor_color() abort
  if &filetype =~ 'list\|\<fern\>'
    hi! link CursorLine CursorLineFocus
  else
    hi! link CursorLine CursorLineDefault
  endif
endfunction
" }}}

" Utils_highligt_textwith_column {{{
highlight EndOfTextWidth guibg=magenta guifg=#282C34
function! hasan#boot#highligt_textwith_column(bool)
  if a:bool
    let w:TW = &textwidth + 1
    let w:EndOfTW = matchadd('EndOfTextWidth', '\%'.w:TW.'v', '100')
    func! RemoveColumnFrmSelectedBuffer(timer)
      if &textwidth == 0
        call clearmatches()
      endif
    endfunc
    let timer = timer_start(50, 'RemoveColumnFrmSelectedBuffer')
  else
    if (exists('w:EndOfTW') && w:EndOfTW > 0)
      try | call matchdelete(w:EndOfTW) | unlet! w:EndOfTW | catch | endtry
    endif
  endif
endfunction
" }}}

" Disable netrw {{{
function! hasan#boot#hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction
" }}}

