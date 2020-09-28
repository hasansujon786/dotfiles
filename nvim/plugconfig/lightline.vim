let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [[ 'mode', 'paste', 'readonly'],
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
      \   'cocstatus': 'coc#status',
      \   'tt_tasktimer': 'LightlineTaskTimer',
      \ },
      \ 'tab_component_function': {
      \   'tabnum': 'LightlineWebDevIcons',
      \ },
      \ 'tabline': {
      \   'left': [[ 'tabs' ]],
      \   'right':[['close'],
      \            [],
      \            ['filetype']]
      \ },
      \
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "", 'right': "" }
      \ }

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
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
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERD_tree' :
        \ &ft == 'fern' ? 'fern' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyModified()
  return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyFilename()
  return (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! LightlineWebDevIcons(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  return WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
endfunction

function! LightlineTaskTimer()
  let s:full_time_and_task = Is_tt_paused() ? ' |paused| ' : tt#get_remaining_full_format() . " " . tt#get_status_formatted() . " " . tt#get_task()
  let s:smart_time = Is_tt_paused() ? ' ' : tt#get_remaining_smart_format()
  return winwidth(0) > 70 && Should_tt_visible() ? s:full_time_and_task : winwidth(0) > 50 ? s:smart_time  : ''
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
