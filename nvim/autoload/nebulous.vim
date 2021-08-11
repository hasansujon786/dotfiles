function!  nebulous#autocmds()
  augroup Nebulous
    au!
    au FocusLost * lua require('nebulous').on_focus_lost()
    au FocusGained * lua require('nebulous').on_focus_gained()
    au WinEnter,BufWinEnter * lua require('nebulous').updateAllWindows()
    au FileType WhichKey call timer_start(0, function('nebulous#whichkey_hack'))
  augroup END
endfunction

function! nebulous#whichkey_hack(...) abort
  lua require('nebulous').on_focus_gained()
  if exists('g:loaded_kissline')
    call kissline#_focus()
  endif
  redrawstatus
endfunction
