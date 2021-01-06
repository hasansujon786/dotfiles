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

function hasan#focus#focus_window() abort
  if &filetype !~? s:focus_window_execute_filetypes
    call setwinvar(0, '&winhighlight', '')
  endif
endfunction

function hasan#focus#blur_window() abort
  if &filetype !~? s:focus_window_execute_filetypes
    call setwinvar(0, '&winhighlight', join(s:winhighlight_blurred,','))
  endif
endfunction

