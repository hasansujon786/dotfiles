"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" statusline#_layout_active {{{
function! statusline#_layout_active()
  let statusline=""
  " first level
  let statusline.="%1*"
  let statusline.=g:statusline.component.mode
  let statusline.=g:statusline.component.readonly
  let statusline.=g:statusline.component.spell
  let statusline.=g:statusline.component.wrap
  let statusline.="%2*"
  let statusline.=g:statusline.separator.left

  if (exists('g:statusline_banner_is_hidden') && !g:statusline_banner_is_hidden)
    let statusline.="%7*"
    let statusline.=g:statusline.component.banner
    let statusline.="%=" " (Middle) align from right
  else

    " second level
    let statusline.="%3*"
    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.modified
    let statusline.=g:statusline.separator.space
    let statusline.="%<" " truncate left
    let statusline.=g:statusline.component.filename
    let statusline.=g:statusline.separator.space
    let statusline.="%4*"
    let statusline.=g:statusline.separator.left
    let statusline.=g:statusline.separator.space

    " third level
    let statusline.="%5*"
    let statusline.=g:statusline.component.coc_status
    let statusline.=g:statusline.separator.space

    let statusline.="%=" " (Middle) align from right

    " third level
    let statusline.="%5*"
    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.tasktimer_status
    let statusline.=g:statusline.separator.space

    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.space_width
    let statusline.=g:statusline.separator.space

    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.filetype
    let statusline.=g:statusline.separator.space

    " second level
    let statusline.="%4*"
    let statusline.=g:statusline.separator.right
    let statusline.="%3*"
    let statusline.=g:statusline.separator.space
    let statusline.=g:statusline.component.percent
    let statusline.=g:statusline.separator.space

  endif

  " first level
  let statusline.="%2*"
  let statusline.=g:statusline.separator.right
  let statusline.="%1*"
  let statusline.=g:statusline.separator.space
  let statusline.=g:statusline.component.lineinfo
  let statusline.=g:statusline.separator.space

  return statusline
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" statusline#_layout_inactive {{{
function! statusline#_layout_inactive()
  let statusline=""
  let statusline.="%6*"
  let statusline.=g:statusline.separator.space
  let statusline.=g:statusline.component.modified
  let statusline.=g:statusline.separator.space
  let statusline.="%<" " turncate left
  let statusline.=g:statusline.component.filename
  let statusline.=g:statusline.separator.space
  let statusline.="%4*"
  let statusline.=g:statusline.separator.left
  let statusline.="%5*"

  let statusline.="%=" " (Middle) align from right

  let statusline.="%5*"
  let statusline.="%4*"
  let statusline.=g:statusline.separator.right
  let statusline.="%6*"
  let statusline.=g:statusline.separator.space
  let statusline.=g:statusline.component.lineinfo
  let statusline.=g:statusline.separator.space

  return statusline
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Controls {{{
function! statusline#_set_colorscheme()
  let colorscheme = get(g:statusline, 'colorscheme', 'one')
  call function('statusline#colorscheme#'.colorscheme.'#_set_colorscheme')()
endfunction
function! statusline#_hide_statusline_colors()
  let colorscheme = get(g:statusline, 'colorscheme', 'one')
  call function('statusline#colorscheme#'.colorscheme.'#_hide_statusline_colors')()
endfunction

function! statusline#_update_all()
  let w = winnr()
  let s = winnr('$') == 1 && w > 0 ? [statusline#_layout_active()] : [statusline#_layout_active(), statusline#_layout_inactive()]
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', s[n!=w])
  endfor
endfunction
function! statusline#_blur()
   call setwinvar(0, '&statusline', statusline#_layout_inactive())
endfunction
function! statusline#_focus()
   call setwinvar(0, '&statusline', statusline#_layout_active())
endfunction

let s:banner_msg_timer_id = 0
function statusline#_show_banner(msg, opts) abort
  if (!g:statusline_banner_is_hidden)
    call timer_stop(s:banner_msg_timer_id)
  endif

  let g:statusline_banner_msg = a:msg
  let g:statusline_banner_is_hidden = 0
  let timer = get(a:opts, 'timer', 5000)
  let s:banner_msg_timer_id = timer_start(timer, 'statusline#_hide_banner')
  call _update_vim_mode_color('v')
  call statusline#_update_all()
endfunction
" call statusline#_show_banner('testing', {'timer': 3000})
" call statusline#_show_banner('testing',{})
function statusline#_hide_banner(timer_id) abort
  let g:statusline_banner_msg = ''
  let g:statusline_banner_is_hidden = 1
  call _update_vim_mode_color('v')
  call statusline#_update_all()
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
