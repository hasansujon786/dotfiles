let s:status_color={
    \ 'n' :'#98C379',
    \ 'v' :'#C678DD',
    \ 'i' :'#61AFEF',
    \ 't' :'#61AFEF',
    \ 'r' :'#E06C75',
    \}

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


function _update_vim_mode_color(mode) abort
  if (hasan#goyo#is_running()) | return | endif

  let bg = get(s:status_color, g:vim_current_mode, 'n')

  exe 'hi User1 guibg='.bg.' guifg=#2C323C gui=bold'
  exe 'hi User2 guifg='.bg.' guibg=#3E4452 gui=bold'
  " if exists('$TMUX')
  "   call s:updateVimuxLine(bg)
  " endif
endfunction

function s:updateVimuxLine(bg)
  call system('tmux set -g window-status-current-format "#[fg=#282C34,bg='.a:bg.',noitalics]#[fg=black,bg='.a:bg.'] #I #[fg=black, bg='.a:bg.'] #W #[fg='.a:bg.', bg=#282C34]"')
endfunction
" let statusline.="%(\ \ %{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}%)\ "

function! _active_status()
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

function! _inactive_status()
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
set statusline=%!_active_status()
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
  autocmd FocusGained,WinEnter,BufEnter,BufDelete,BufWinLeave,SessionLoadPost,FileChangedShellPost * call s:statusline_update()
  autocmd FocusLost * call Blur_statusline()
augroup END

function! s:statusline_update()
  let w = winnr()
  let s = winnr('$') == 1 && w > 0 ? [_active_status()] : [_active_status(), _inactive_status()]
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', s[n!=w])
  endfor
endfunction

function! Blur_statusline()
   call setwinvar(0, '&statusline', _inactive_status())
endfunction
function! Focus_statusline()
   call setwinvar(0, '&statusline', _active_status())
endfunction
function! Update_all_statusline()
  call s:statusline_update()
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

