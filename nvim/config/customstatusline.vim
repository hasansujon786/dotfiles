let g:nerdfont_loaded = 0
let g:statusline_banner_msg = ''
let g:statusline_banner_is_hidden = 1

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

  if (exists('g:statusline_banner_is_hidden') && !g:statusline_banner_is_hidden)
    exe 'hi User1 guibg='.bg.' guifg=#2C323C gui=bold'
    exe 'hi User2 guifg='.bg.' guibg=tomato gui=bold'
  else
    exe 'hi User1 guibg='.bg.' guifg=#2C323C gui=bold'
    exe 'hi User2 guifg='.bg.' guibg=#3E4452 gui=bold'
  endif
  " if exists('$TMUX')
  "   call s:updateVimuxLine(bg)
  " endif
endfunction

function s:updateVimuxLine(bg)
  call system('tmux set -g window-status-current-format "#[fg=#282C34,bg='.a:bg.',noitalics]#[fg=black,bg='.a:bg.'] #I #[fg=black, bg='.a:bg.'] #W #[fg='.a:bg.', bg=#282C34]"')
endfunction
" let statusline.="%(\ \ %{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}%)\ "

" file:/data/data/com.termux/files/usr/share/nvim/runtime/doc/options.txt:5797
let g:statusline = {
  \ 'component': {
  \   'mode': "\ %{toupper(g:currentmode[mode()])}\ ",
  \   'readonly': "%{&readonly?'\ ".s:ic.lock." ':''}",
  \   'spell': "%{&spell?'\ ".s:ic.dic." ':''}",
  \   'wrap': "%{&wrap?'\ ".s:ic.wrap." ':''}",
  \   'modified': "%{&modified?'●':!g:nerdfont_loaded?'':nerdfont#find()}",
  \   'space_width': "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}",
  \   'filetype': "%{''!=#&filetype?&filetype:'none'}",
  \   'filename': "%t",
  \   'percent': "%3p%%",
  \   'lineinfo': "%3l:%-2v",
  \   'coc_status': "%{CocStatus()}",
  \   'tasktimer_status': "%{TaskTimerStatus()}",
  \   'banner': "%{Banner_msg()}",
  \   },
  \ 'separator': {'left': '', 'right': '', 'space': ' '},
  \ 'subseparator': {'left': '', 'right': ''},
  \ }

function! _active_status()
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
    let statusline.="%=" " (Middl e) align from right
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

function! _inactive_status()
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
" Banner section color
hi User7 guibg=tomato guifg=white gui=bold
" hi User8 guibg=tomato guifg=#ABB2BF
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

function Banner_msg() abort
  let msg = exists('g:statusline_banner_msg') ? g:statusline_banner_msg : ''
  let banner_w = (winwidth(0) - 18) / 2
  let space = banner_w + (len(msg) / 2)
  let line = printf('%'.space.'S', msg)
  return exists('g:statusline_banner_is_hidden') && !g:statusline_banner_is_hidden ? line : ''
endfunction

let s:banner_msg_timer_id = 0
function Banner_msg_show(msg, opts) abort
  if (!g:statusline_banner_is_hidden)
    echo 'already'
    call timer_stop(s:banner_msg_timer_id)
  endif

  let g:statusline_banner_msg = a:msg
  let g:statusline_banner_is_hidden = 0
  let timer = get(a:opts, 'timer', 30000)
  let s:banner_msg_timer_id = timer_start(timer, 'Banner_msg_hide')
  call _update_vim_mode_color('v')
  call Update_all_statusline()
endfunction
" call Banner_msg_show('tisting', {'timer': 3000})
" call Banner_msg_show('tisting',{})
function Banner_msg_hide(timer_id) abort
  let g:statusline_banner_msg = ''
  let g:statusline_banner_is_hidden = 1
  call _update_vim_mode_color('v')
  call Update_all_statusline()
endfunction
