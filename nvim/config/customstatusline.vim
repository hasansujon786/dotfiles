
let s:ic = {
\ 'lock':     '',
\ 'checking': '',
\ 'warning':  '',
\ 'error':    '',
\ 'ok':       '',
\ 'info':     '',
\ 'hint':     '',
\ 'line':     '',
\ 'dic':      ' ',
\ 'wrap':     '蝹',
\ 'cup':      '',
\ 'search':   '',
\ 'pomodoro': '',
\ 'separator': {'left': '', 'right': ''},
\ 'subseparator': {'left': '', 'right': ''},
\ 'space': ' '
\}

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V-Line',
    \ "\<C-V>" : 'V-Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S-Line',
    \ "\<C-S>" : 'S-Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V-Replace',
    \ 'c'  : 'Normal',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}


" let statusline.="%(\ \ %{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}%)\ "

function! ActiveStatus()
  let statusline=""
  let statusline.="%1*"
  let statusline.="\ %{toupper(g:currentmode[mode()])}\ "
  let statusline.="%{&readonly?'\ ".s:ic.lock." ':''}"
  let statusline.="%{&spell?'\ ".s:ic.dic." ':''}"
  let statusline.="%{&wrap?'\ ".s:ic.wrap." ':''}"
  let statusline.="%2*"
  let statusline.=s:ic.separator.left
  let statusline.=s:ic.space
  let statusline.="%3*"
  let statusline.="%{&modified?'●':nerdfont#find()}"
  let statusline.=s:ic.space
  let statusline.="%3*"
  let statusline.="%<"
  let statusline.="%t"
  let statusline.=s:ic.space
  let statusline.="%4*"
  let statusline.=s:ic.separator.left

  let statusline.=s:ic.space
  let statusline.="%5*"
  let statusline.="%{CocStatus()}"
  let statusline.=s:ic.space

  let statusline.="%=" " Middle
  let statusline.="%5*"

  let statusline.=s:ic.space
  let statusline.="%{TaskTimerStatus()}"
  let statusline.=s:ic.space

  let statusline.=s:ic.space
  let statusline.="%{&expandtab?'Spc:':'Tab:'}"
  let statusline.="%{&shiftwidth}"
  let statusline.=s:ic.space

  let statusline.=s:ic.space
  let statusline.="%{''!=#&filetype?&filetype:'none'}"
  let statusline.=s:ic.space

  let statusline.="%4*"
  let statusline.=s:ic.separator.right
  let statusline.="%3*"
  let statusline.=s:ic.space
  let statusline.="%3p%%"
  let statusline.=s:ic.space

  let statusline.="%2*"
  let statusline.=s:ic.separator.right
  let statusline.="%1*"
  let statusline.=s:ic.space
  let statusline.="%3l:%-2v"
  let statusline.=s:ic.space
  return statusline
endfunction

function! InactiveStatus()
  let statusline=""
  let statusline.="%6*"
  let statusline.=s:ic.space
  let statusline.="%<"
  let statusline.="%{&modified?'●':nerdfont#find()}"
  let statusline.=s:ic.space
  let statusline.="%t"
  let statusline.=s:ic.space
  let statusline.="%4*"
  let statusline.=s:ic.separator.left

  let statusline.="%5*"
  let statusline.="%="
  let statusline.="%5*"

  let statusline.="%4*"
  let statusline.=s:ic.separator.right
  let statusline.="%6*"
  let statusline.=s:ic.space
  let statusline.="%3p%%"
  let statusline.=s:ic.space

  return statusline
endfunction

set laststatus=2
set statusline=%!ActiveStatus()
" Mode color
hi User1 guibg=#98C379 guifg=#2C323C gui=bold
hi User2 guibg=#3E4452 guifg=#98C379
" Secondary section color
hi User3 guibg=#3E4452 guifg=#ABB2BF
hi User4 guibg=#2C323C guifg=#3E4452
" Statusline middle
hi User5 guibg=#2C323C guifg=#717785
" Secondary section color (inactive)
hi User6 guibg=#3E4452 guifg=#717785
" Default color
hi statusline   guibg=#2C323C guifg=#ABB2BF
hi StatusLineNC guibg=#2C323C guifg=#717785

augroup status
  autocmd WinEnter,BufEnter,BufDelete,BufWinLeave,SessionLoadPost,FileChangedShellPost * call s:statusline_update()
augroup END

function! s:statusline_update()
  let w = winnr()
  let s = winnr('$') == 1 && w > 0 ? [ActiveStatus()] : [ActiveStatus(), InactiveStatus()]
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', s[n!=w])
  endfor
endfunction

function! LightLineBufSettings()
    let et = &et ==# 1 ? "•" : "➜"
    return ('│ts│'. &tabstop . '│sw│'. &shiftwidth . '│et│' . et . '│')
endfunction

function! CocStatus()
  " . get(b:,'coc_current_function','')
  return exists('*coc#status') ? coc#status() : ''
endfunction

function! TaskTimerStatus()
  if !exists('g:all_plug_loaded')
    return s:ic.checking
  else | try
    let icon = tt#get_status() =~ 'break' ? s:ic.cup : s:ic.pomodoro
    let status = (!tt#is_running() && !hasan#tt#is_tt_paused() ? 'off' :
          \ hasan#tt#is_tt_paused() ? 'paused' :
          \ tt#get_remaining_smart_format())
    return icon.' '.status
    catch | return '' | endtry
  endif
endfunction

