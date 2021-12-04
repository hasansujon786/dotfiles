function!  nebulous#autocmds()
  augroup Nebulous
    au!
    au FocusLost * lua require('nebulous').on_focus_lost()
    au FocusGained * lua require('nebulous').on_focus_gained()
    au WinEnter,BufWinEnter * lua require('nebulous').update_all_windows()
    au FileType WhichKey call timer_start(0, function('nebulous#whichkey_hack'))
    au ColorScheme * lua require('nebulous').setup_colors()
  augroup END
endfunction

function!  nebulous#autocmds_remove()
  augroup Nebulous
    au!
  augroup END
endfunction

function! nebulous#whichkey_hack(...) abort
  lua require('nebulous').on_focus_gained()
  redrawstatus
endfunction
