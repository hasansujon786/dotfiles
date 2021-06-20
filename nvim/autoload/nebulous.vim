let s:nebulous_disabled = 0
let s:nebulous_on_blur_highlights = [
      \ 'CursorLineNr:NebulousCursorLineNr',
      \ 'Normal:Nebulous',
      \ 'NormalNC:Nebulous',
      \ 'EndOfBuffer:Nebulous',
      \ ]
let s:nebulous_ignored_filetypes = {
      \ 'fzf': 1,
      \ 'floating': 1,
      \ 'qf': 1,
      \ 'TelescopePrompt': 1,
      \ }
let s:nebulous_on_focus_highlights_by_filetype = {
      \ 'floaterm': [
      \   'Normal:Floaterm',
      \   'NormalNC:FloatermNC'
      \ ]
      \ }


function! nebulous#init() abort
  hi Nebulous guibg=#363d49
  hi NebulousCursorLineNr guifg=#4B5263
endfunction
call nebulous#init()

function! nebulous#toggle() abort
  if nebulous#is_disabled()
    let s:nebulous_disabled = v:false

    call nebulous#init()
    call nebulous#focus_window()
    call _#Echo(['TextInfo', '[Nebulous]'], 'on')
  else
    let s:nebulous_disabled = v:true

    for cur_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
      if (!s:win_has_ignored_filetype(cur_nr))
        call s:remove_blur(cur_nr)
      endif
    endfor
    call _#Echo(['TextInfo', '[Nebulous]'], 'off')
  endif
endfunction

function! nebulous#focus_window() abort
  if nebulous#is_disabled() | return | endif

  for cur_nr in range(1, tabpagewinnr(tabpagenr(), '$'))
    " if current window
    if (cur_nr == winnr() && !s:win_has_ignored_filetype(cur_nr))
      call s:remove_blur(cur_nr)
    " other windows
    elseif (!s:win_has_ignored_filetype(cur_nr))
      call s:add_blur(cur_nr)
    endif
  endfor
endfunction

function! nebulous#blur_current_window() abort
  if nebulous#is_disabled() | return | endif
  if (!s:win_has_ignored_filetype(0))
    call s:add_blur(0)
  endif
endfunction

function! s:win_has_ignored_filetype(win_nr) abort
  return get(s:nebulous_ignored_filetypes, getwinvar(a:win_nr, '&ft'), 0)
endfunction

function! nebulous#is_disabled() abort
  return s:nebulous_disabled
endfunction

function! s:remove_blur(win_nr) abort
  let nebulous_highlight_color = get(s:nebulous_on_focus_highlights_by_filetype, &ft, '')
  if _#isString(nebulous_highlight_color)
    call setwinvar(a:win_nr, '&winhighlight', '')
  else
    call setwinvar(a:win_nr, '&winhighlight', join(nebulous_highlight_color,','))
  endif
endfunction

function! s:add_blur(win_nr) abort
  call setwinvar(a:win_nr, '&winhighlight', join(s:nebulous_on_blur_highlights,','))
endfunction

function! nebulous#block(...) abort
 let s:nebulous_disabled = v:true
endfunction

function! nebulous#unblock(...) abort
 let s:nebulous_disabled = v:false
endfunction

function! nebulous#onTelescopeStart() abort
  if nebulous#is_disabled() | return | endif

  call nebulous#blur_current_window()
  call nebulous#block()
  augroup NebulousTelescope
    autocmd!
    autocmd WinClosed * call nebulous#onTelescopeClosed()
  augroup end
endfunction

function! nebulous#onTelescopeClosed() abort
  call nebulous#unblock()
  autocmd! NebulousTelescope
endfunction

