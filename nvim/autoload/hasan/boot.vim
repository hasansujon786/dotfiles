
" AutoSetCursorColor {{{
function! hasan#boot#auto_set_cursor_color() abort
  if &filetype =~ 'list\|fugitive\|fern'
    highlight CursorLine guibg=#3E4452
  else
    highlight CursorLine guibg=#2C323C
  endif

  if &filetype =~ 'fern'
    highlight Cursor ctermfg=235 ctermbg=39 guifg=#282C34 guibg=#3E4452
  else
    highlight Cursor ctermfg=235 ctermbg=39 guifg=#282C34 guibg=#61AFEF
  endif
endfunction
" }}}

" Utils_highligt_textwith_column {{{
highlight ColorColumn guibg=magenta guifg=#282C34 ctermbg=gray  ctermfg=white
function! hasan#boot#highligt_textwith_column(bool)
  if a:bool
    let w:TW = &textwidth + 1
    let w:EndOfTW = matchadd('ColorColumn', '\%'.w:TW.'v', '100')
  else
    if (exists('w:EndOfTW') && w:EndOfTW > 0)
      try | call matchdelete(w:EndOfTW) | unlet! w:EndOfTW | catch | endtry
    endif
  endif
endfunction
" }}}

" Disable netrw {{{
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

function! hasan#boot#hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction
" }}}

