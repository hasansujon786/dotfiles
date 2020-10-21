let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [[ 'mode', 'paste', 'readonly', 'spell'],
      \            [ 'fugitive', 'filename',],
      \            [ 'cocstatus' ]],
      \
      \ 'right':  [[ 'lineinfo' ],
      \            [ 'percent'  ],
      \            [ 'tt_tasktimer']],
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"":""}',
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'MyFilename',
      \   'filetype': 'MyFiletype',
      \   'mode': 'MyMode',
      \   'spell': 'MySpell',
      \   'cocstatus': 'coc#status',
      \   'tt_tasktimer': 'LightlineTaskTimer',
      \ },
      \ 'tab_component_function': {
      \   'tabnum': 'LightlineNerdfontIcons',
      \ },
      \ 'tabline': {
      \   'left': [[ 'tabs' ]],
      \   'right':[['close'],
      \            [],
      \            ['filetype']]
      \ },
      \
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    " return winwidth(0) > 60 ? branch !=# '' ? ' '.branch : '' : ''
    " Print only if branch is not master
    return branch ==# 'master' ? '' : winwidth(0) > 60 ? branch !=# '' ? ' '.branch : '' : ''
  endif
  return ''
endfunction

function! MyFiletype()
  return strlen(&filetype) ? &filetype : 'no ft'
  " return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  " return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? 'NERD_tree' :
        \ &ft == 'fern' ? 'fern' :
        \ &ft == 'spacevimtodomanager' ? 'TODO' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MySpell()
  return winwidth(0) > 60 && &spell ? ' ' : ''
endfunction

function! MyModified()
  return &modified ? '*' : &modifiable ? '-' : '~'
endfunction

function! MyFilename()
  return ('' != MyModified() ? MyModified() : '').' '.
        \(&ft == 'fugitive' ? 'fugitive' :
        \ &ft == 'spacevimtodomanager' ? 'TODO manager' :
        \  '' != expand('%:t') ? expand('%:t') : '[No Name]')
endfunction

function! LightlineNerdfontIcons(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  return nerdfont#find(bufname(l:bufnr))
endfunction

function! LightlineTaskTimer()
  try
    if Should_tt_visible()
      let l:full_tt = Is_tt_paused() ? '|  | ' : tt#get_remaining_full_format() . " " . tt#get_status_formatted() . " " . tt#get_task()
      let l:smart_tt = Is_tt_paused() ? '' : tt#get_remaining_smart_format()
      return winwidth(0) > 70 ? l:full_tt : winwidth(0) > 50 ? l:smart_tt  : ''
    endif
    return ''
  catch
    return ''
  endtry
endfunction

" => itchyny/lightline.vim =================================
let s:palette = g:lightline#colorscheme#one#palette
let s:palette.normal.middle = [ [ '#717785', '#2C323C', 252, 66] ]
let s:palette.inactive.left = [ [ '#717785', '#3E4452', 252, 66] ]
let s:palette.inactive.right = [ [ '#717785', '#3E4452', 252, 66] ]

let s:palette.tabline.tabsel = [ [ '#282C33', '#ABB2BF', 252, 66, 'bold' ] ]
let s:palette.tabline.left = [ [ '#717785', '#3E4452', 252, 66 ] ]
let s:palette.tabline.middle = [ [ '#717785', '#2C323C', 252, 66 ] ]
unlet s:palette

" https://github.com/itchyny/lightline.vim/issues/9
