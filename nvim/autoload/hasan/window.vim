
function! hasan#window#toggle_quickfix(global) "{{{
  for winNr in range(1, winnr('$'))
    let bufNr = winbufnr(winNr)
    if getbufvar(bufNr, '&buftype') == 'quickfix'
      let winInfo = getwininfo(win_getid(winNr))[0]
      let foundQuickfix = winInfo.quickfix == 1 && winInfo.loclist == 0
      call nvim_win_close(win_getid(winNr), 0)

      if (a:global && !foundQuickfix)       " want quickfix but found loclist
        copen
      elseif (!a:global && foundQuickfix)   " want loclist but found quickfix
        lopen
      endif

      return
    endif
  endfor
  exe a:global ? 'copen' : 'lopen'
endfunction "}}}

