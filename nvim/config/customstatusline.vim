
let s:ic = {
\ 'lock':     '',
\ 'checking': '',
\ 'warning':  '',
\ 'error':    '',
\ 'ok':       '',
\ 'info':     '',
\ 'hint':     '',
\ 'line':     '',
\ 'dic':      '📖',
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
  let fModifiedColor = &modified ? '%9*' : '%3*'
  let statusline=""
  let statusline.="%1*"
  let statusline.="\ %{toupper(g:currentmode[mode()])}\ "
  let statusline.="%{&readonly?'\ \  ':''}"
  let statusline.="%{&spell?'\ \ 📖 ':''}"
  let statusline.="%2*"
  let statusline.=s:ic.separator.left
  let statusline.=fModifiedColor
  let statusline.=s:ic.space
  let statusline.="%{&modified?'●':'-'}"
  let statusline.=s:ic.space
  let statusline.="%3*"
  let statusline.="%<"
  let statusline.="%t"
  let statusline.=s:ic.space
  let statusline.="%4*"
  let statusline.=s:ic.separator.left

  let statusline.="%5*"
  let statusline.="%="
  let statusline.="%5*"

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
  let statusline.="%{&modified?'●':'-'}"
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

let g:bg = 'blue'
set laststatus=2
set statusline=%!ActiveStatus()
hi User1 guibg=#98C379 guifg=#2C323C gui=bold
hi User2 guibg=#3E4452 guifg=#98C379
hi User3 guibg=#3E4452 guifg=#ABB2BF
hi User4 guibg=#2C323C guifg=#3E4452
" statusline middle
hi User5 guibg=#2C323C guifg=#717785
hi User6 guibg=#3E4452 guifg=#717785
" fModifiedColor
hi User9 guibg=#3E4452 guifg=#E06C75
hi User8 guibg=#3E4452 guifg=#717785


" au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
" au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan

hi statusline guifg=black guibg=#2C323C ctermfg=black ctermbg=cyan
hi StatusLineNC guifg=#717785 guibg=#2C323C ctermfg=black ctermbg=cyan

augroup status
  autocmd!
  autocmd WinEnter,BufEnter,FocusGained * setlocal statusline=%!ActiveStatus()
  autocmd WinLeave,BufLeave,FocusLost * setlocal statusline=%!InactiveStatus()
augroup END

function! LightLineBufSettings()
    let et = &et ==# 1 ? "•" : "➜"
    return ('│ts│'. &tabstop . '│sw│'. &shiftwidth . '│et│' . et . '│')
endfunction



