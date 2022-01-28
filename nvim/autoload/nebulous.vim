function!  nebulous#autocmds()
  augroup Nebulous
    au!
    au FocusLost * lua require('nebulous').on_focus_lost()
    au FocusGained * lua require('nebulous').on_focus_gained()
    au WinEnter,BufWinEnter * lua require('nebulous').update_all_windows(true)
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

function! nebulous#onWinEnter(winId) abort
  call timer_start(50, funcref('nebulous#focus_cursor', [a:winId]))
endfunction

let s:cursorline_focus_ft = 'list\|\<fern\>'
let s:cursorline_disable_ft = 'dashboard\|floaterm'
let s:cursorline_disable_bt = 'prompt'

function! nebulous#focus_cursor(...) abort
  if &ft =~ s:cursorline_disable_ft || &buftype =~ s:cursorline_disable_bt
    return 0
  endif

  if &filetype =~ 'org'
    setl winhighlight=Folded:TextInfo
  endif
  if &filetype =~ s:cursorline_focus_ft
    set winhighlight=CursorLine:CursorLineFocus
  endif
  try | call nvim_win_set_option(a:000[0], 'cursorline', v:true) | catch | endtry
endfunction

