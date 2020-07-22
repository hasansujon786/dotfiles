Plug 'itchyny/lightline.vim'

" => itchyny/lightline.vim =================================
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
      \            [ 'filetype' ]],
      \ },
      \   'component': {
      \   'readonly': '%{&readonly?"":""}',
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'MyFilename',
      \   'filetype': 'MyFiletype',
      \   'mode': 'MyMode',
	    \   'cocstatus': 'coc#status'
      \ },
      \ 'tab_component_function': {
      \   'tabnum': 'LightlineWebDevIcons',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return winwidth(0) > 60 ? branch !=# '' ? ' '.branch : '' : ''
  endif
  return ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  " return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
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
