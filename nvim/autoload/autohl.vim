" !::exe [Redraw | So | Error 'ha']

" nnoremap z/ :call autohl#_AutoHighlightToggle()<CR>

function! autohl#_AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    if exists('w:auto_highlight_id')
      call matchdelete(w:auto_highlight_id)
      unlet w:auto_highlight_id
    end
    setl updatetime=1000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorMoved,BufEnter * call <SID>autoHighlight()
      au BufLeave * call <SID>deleteAutoHighlight()
    augroup end
    setl updatetime=100
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

function! s:autoHighlight()
  if &buftype != ''
    return
  end
  call s:deleteAutoHighlight()
  let w:auto_highlight_id = matchadd('ColorColumn', '\V\<'.escape(expand('<cword>'), '\').'\>')
endfunction

function! s:deleteAutoHighlight()
  if exists('w:auto_highlight_id')
    call matchdelete(w:auto_highlight_id)
    unlet w:auto_highlight_id
  end
endfunction
