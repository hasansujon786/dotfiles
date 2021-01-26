" @todo add custom hilight for selected filetype (ex: terminal)
" hi WindowBlur guibg=#2C323C
hi WindowBlur guibg=#363d49
hi EndOfBufferWB guifg=#2C323C
hi CursorLineNrWB guifg=#4B5263

let s:winhighlight_blurred = [
      \ 'CursorLineNr:CursorLineNrWB',
      \ 'EndOfBuffer:EndOfBufferWB',
      \ 'IncSearch:WindowBlur',
      \ 'Normal:WindowBlur',
      \ 'NormalNC:WindowBlur',
      \ 'SignColumn:WindowBlur'
      \ ]

let s:focus_window_execute_filetypes = {
      \ 'fzf': 1,
      \ }

function! hasan#focus#focus_window() abort
  if s:is_focus_disabled() | return | endif

  call s:add_focus_and_other_win_blur(0)
endfunction

function! hasan#focus#blur_this_window() abort
  if s:is_focus_disabled() | return | endif

  if (s:should_blur(0))
    call setwinvar(0, '&winhighlight', join(s:winhighlight_blurred,','))
  endif
endfunction

function! hasan#focus#toggle() abort
  if s:is_focus_disabled()
    call hasan#focus#eneble()
  else
    call hasan#focus#disable()
  endif
endfunction

function! hasan#focus#eneble()
  hi WindowBlur guibg=#363d49
  hi EndOfBufferWB guifg=#2C323C
  hi CursorLineNrWB guifg=#4B5263

  let g:focus_is_disabled = v:false
  call s:add_focus_and_other_win_blur(0)
endfunction

function! hasan#focus#disable()
  let g:focus_is_disabled = v:true

  for cur_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    if (s:should_blur(cur_nr))
      call setwinvar(cur_nr, '&winhighlight', '')
    endif
  endfor
endfunction

function! s:add_focus_and_other_win_blur(blur) abort
  for cur_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    if (cur_nr == winnr() && s:should_blur(cur_nr))
      call setwinvar(0, '&winhighlight', '')

    elseif (s:should_blur(cur_nr))
      call setwinvar(cur_nr, '&winhighlight', join(s:winhighlight_blurred,','))
    endif
  endfor
endfunction

function! s:should_blur(win_nr) abort
  return !get(s:focus_window_execute_filetypes, getwinvar(a:win_nr, '&ft'), 0)
endfunction

function! s:is_focus_disabled() abort
  return exists('g:focus_is_disabled') && g:focus_is_disabled == v:true
endfunction
