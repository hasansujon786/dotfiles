let s:is_disabled = 0
let s:winhighlight_blurred = [
      \ 'CursorLineNr:NebulousCursorLineNr',
      \ 'Normal:Nebulous',
      \ 'NormalNC:Nebulous',
      \ ]
let s:nebulous_ignored_filetypes = {
      \ 'fzf': 1,
      \ 'floating': 1,
      \ 'qf': 1,
      \ }
let s:nebulous_highlight_colors_for_filetype = {
      \ 'floaterm': [
      \ 'Normal:Floaterm',
      \ 'NormalNC:FloatermNC'
      \ ]
      \ }


function! nebulous#init() abort
  hi Nebulous guibg=#363d49
  hi NebulousCursorLineNr guifg=#4B5263
endfunction
call nebulous#init()

function! nebulous#toggle() abort
  if nebulous#is_disabled()
    call nebulous#eneble()
  else
    call nebulous#disable()
  endif
endfunction

function! nebulous#eneble()
  call nebulous#init()
  let s:is_disabled = v:false
  call s:focus_current_win_and_blur_other_wins()
  call _#Echo(['TextInfo', '[Nebulous]'], 'on')
endfunction

function! nebulous#disable()
  let s:is_disabled = v:true

  for cur_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    if (!s:win_has_ignored_filetype(cur_nr))
      call setwinvar(cur_nr, '&winhighlight', '')
    endif
  endfor
  call _#Echo(['TextInfo', '[Nebulous]'], 'off')
endfunction

function! nebulous#focus_window() abort
  if nebulous#is_disabled() | return | endif
  call s:focus_current_win_and_blur_other_wins()
endfunction

function! nebulous#blur_this_window() abort
  if nebulous#is_disabled() | return | endif
  if (!s:win_has_ignored_filetype(0))
    call setwinvar(0, '&winhighlight', join(s:winhighlight_blurred,','))
  endif
endfunction

function! s:focus_current_win_and_blur_other_wins() abort
  for cur_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    " if current window
    if (cur_nr == winnr() && !s:win_has_ignored_filetype(cur_nr))
      let nebulous_highlight_color = get(s:nebulous_highlight_colors_for_filetype, &ft, '')
      if _#isString(nebulous_highlight_color)
        call setwinvar(0, '&winhighlight', '')
      else
        call setwinvar(cur_nr, '&winhighlight', join(nebulous_highlight_color,','))
      endif

    " other windows
    elseif (!s:win_has_ignored_filetype(cur_nr))
      call setwinvar(cur_nr, '&winhighlight', join(s:winhighlight_blurred,','))
    endif
  endfor
endfunction

function! s:win_has_ignored_filetype(win_nr) abort
  return get(s:nebulous_ignored_filetypes, getwinvar(a:win_nr, '&ft'), 0)
endfunction

function! nebulous#is_disabled() abort
  return s:is_disabled
endfunction
