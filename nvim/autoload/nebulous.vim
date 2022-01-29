function!  nebulous#autocmds()
  augroup Nebulous
    au!
    au FocusLost * lua require('nebulous').on_focus_lost()
    au FocusGained * lua require('nebulous').on_focus_gained()
    au WinEnter,BufWinEnter * lua require('nebulous').update_all_windows(true)
    au ColorScheme * lua require('nebulous').setup_colors()
  augroup END
endfunction

function!  nebulous#autocmds_remove()
  augroup Nebulous
    au!
  augroup END
endfunction

let s:timer = 0
function! nebulous#onWinEnter(winId) abort
  call timer_stop(s:timer)
  let s:timer = timer_start(50, funcref('nebulous#focus_cursor', [a:winId]))
endfunction

let s:cursorline_focus_ftype = 'list\|\<fern\>'
let s:cursorline_disable_ftype = 'dashboard\|floaterm'
let s:cursorline_disable_btype = 'prompt'

function! nebulous#focus_cursor(...) abort
  let winId = a:000[0]
  let bufnr = nvim_win_get_buf(winId)
  let ftype = nvim_buf_get_option(bufnr, 'filetype')
  let btype = nvim_buf_get_option(bufnr, 'buftype')

  if ftype =~ s:cursorline_disable_ftype || btype =~ s:cursorline_disable_btype
    return 0
  endif

  if ftype =~ 'org'
    setl winhighlight=Folded:TextInfo
  endif
  if ftype =~ s:cursorline_focus_ftype
    set winhighlight=CursorLine:CursorLineFocus
  endif
  try | call nvim_win_set_option(winId, 'cursorline', v:true) | catch | endtry
endfunction

