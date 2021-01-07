hi WindowBlur guibg=#2C323C
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

let s:focus_window_execute_filetypes = 'fzf'

function! hasan#focus#focus_window() abort
  if (exists('g:focus_is_disabled') && g:focus_is_disabled == v:true) | return | endif

  if &filetype !~? s:focus_window_execute_filetypes
    call setwinvar(0, '&winhighlight', '')
  endif
endfunction

function! hasan#focus#blur_window() abort
  if (exists('g:focus_is_disabled') && g:focus_is_disabled == v:true) | return | endif

  if &filetype !~? s:focus_window_execute_filetypes
    call setwinvar(0, '&winhighlight', join(s:winhighlight_blurred,','))
  endif
endfunction

function! hasan#focus#toggle() abort
  if (exists('g:focus_is_disabled') && g:focus_is_disabled == v:true)
    call hasan#focus#eneble()
  else
    call hasan#focus#disable()
  endif
endfunction

function! hasan#focus#eneble()
  hi WindowBlur guibg=#2C323C
  hi EndOfBufferWB guifg=#2C323C
  hi CursorLineNrWB guifg=#4B5263

  let g:focus_is_disabled = v:false

  for win_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    if &filetype !~? s:focus_window_execute_filetypes
      call setwinvar(win_nr, '&winhighlight', join(s:winhighlight_blurred,','))
    endif
  endfor
  if &filetype !~? s:focus_window_execute_filetypes
    call setwinvar(0, '&winhighlight', '')
  endif
endfunction

function! hasan#focus#disable()
  let g:focus_is_disabled = v:true

  for win_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    if &filetype !~? s:focus_window_execute_filetypes
      call setwinvar(win_nr, '&winhighlight', '')
    endif
  endfor
endfunction

