"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global values {{{
let g:nerdfont_loaded = 0
let g:statusline_banner_msg = ''
let g:statusline_banner_is_hidden = 1

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


let g:icon = {
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


" file:/data/data/com.termux/files/usr/share/nvim/runtime/doc/options.txt:5797
let g:statusline = {
  \ 'colorscheme': 'one',
  \ 'component': {
  \   'mode': "\ %{toupper(g:currentmode[mode()])}\ ",
  \   'readonly': "%{&readonly?'\ ".g:icon.lock." ':''}",
  \   'spell': "%{&spell?'\ ".g:icon.dic." ':''}",
  \   'wrap': "%{&wrap?'\ ".g:icon.wrap." ':''}",
  \   'modified': "%{&modified?'●':!g:nerdfont_loaded?'':nerdfont#find()}",
  \   'space_width': "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}",
  \   'filetype': "%{''!=#&filetype?&filetype:'none'}",
  \   'filename': "%t",
  \   'percent': "%3p%%",
  \   'lineinfo': "%3l:%-2v",
  \   'coc_status': "%{CocStatus()}",
  \   'tasktimer_status': "%{TaskTimerStatus()}",
  \   'banner': "%{BannerMsg()}",
  \   },
  \ 'separator': {'left': '', 'right': '', 'space': ' '},
  \ 'subseparator': {'left': '', 'right': ''},
  \ }
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Component functions {{{

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
    return g:icon.checking
  else | try
    let icon = tt#get_status() =~ 'break' ? g:icon.cup : g:icon.pomodoro
    let status = (!tt#is_running() && !hasan#tt#is_tt_paused() ? 'off' :
          \ hasan#tt#is_tt_paused() ? 'paused' :
          \ tt#get_remaining_smart_format())
    return icon.' '.status
    catch | return '' | endtry
  endif
endfunction

function BannerMsg() abort
  let msg = exists('g:statusline_banner_msg') ? g:statusline_banner_msg : ''
  let banner_w = (winwidth(0) - 18) / 2
  let space = banner_w + (len(msg) / 2)
  let line = printf('%'.space.'S', msg)
  return exists('g:statusline_banner_is_hidden') && !g:statusline_banner_is_hidden ? line : ''
endfunction

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


set statusline=%!statusline#_layout_active()
augroup StausLine
  au!
  au FocusGained,WinEnter,BufEnter,BufDelete,BufWinLeave,SessionLoadPost,FileChangedShellPost
        \ * call statusline#_update_all()
  au FocusLost * call statusline#_blur()
  au VimEnter * call statusline#_set_colorscheme()
  au User GoyoLeave nested call statusline#_set_colorscheme()
augroup END

