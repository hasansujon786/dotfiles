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
      \ 'floating': 1,
      \ }

let s:focus_highlight_colors_for_filetype = {
      \ 'floaterm': [
      \ 'Normal:Floaterm',
      \ 'NormalNC:FloatermNC'
      \ ]
      \ }

function! hasan#focus#focus_window() abort
  if s:is_focus_disabled() | return | endif

  call s:focus_current_win_and_blur_other_wins(0)
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
  call s:focus_current_win_and_blur_other_wins(0)
endfunction

function! hasan#focus#disable()
  let g:focus_is_disabled = v:true

  for cur_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    if (s:should_blur(cur_nr))
      call setwinvar(cur_nr, '&winhighlight', '')
    endif
  endfor
endfunction

function! s:focus_current_win_and_blur_other_wins(blur) abort
  for cur_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    " if current window
    if (cur_nr == winnr() && s:should_blur(cur_nr))
      let focus_highlight_color = get(s:focus_highlight_colors_for_filetype, &ft, '')
      if _#isString(focus_highlight_color)
        call setwinvar(0, '&winhighlight', '')
      else
        call setwinvar(cur_nr, '&winhighlight', join(focus_highlight_color,','))
      endif

    " other windows
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
