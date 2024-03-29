
" Utils_highligt_textwith_column {{{
highlight EndOfTextWidth guibg=magenta guifg=#282C34
function! hasan#boot#highligt_ruler(bool)
  if a:bool
    let w:TW = &textwidth + 2
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
  augroup HighlightRuler
    au!
    au WinLeave,BufWinLeave <buffer> call hasan#boot#highligt_ruler(0)
  augroup END
endfunction
" }}}

