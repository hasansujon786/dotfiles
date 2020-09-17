noremap <silent> <Leader>n :Fern . -drawer -toggle -reveal=%<CR><C-w>=
" Open current file directory into the drawer
noremap <silent> <Leader>. :call Before_Try_To_select_last_file()<CR>
      \:Fern %:h -drawer <CR>
      \:call Try_To_select_last_file(300)<CR>
" Open current file directory into the buffer
nnoremap <silent> - :call Before_Try_To_select_last_file()<CR>
      \:Fern <C-r>=<SID>smart_path()<CR><CR>
      \:call Try_To_select_last_file(200)<CR>
" Open bookmarks
nnoremap <silent> <Leader>ii :<C-u>Fern bookmark:///<CR>

let g:fern#keepalt_on_edit = 1
let g:fern#default_hidden = 1
let g:fern#disable_default_mappings   = 1
let g:fern#disable_drawer_auto_quit   = 1
let g:fern#default_exclude = 'node_modules'
" let g:fern#disable_viewer_hide_cursor = 1
let g:fern_git_status#disable_ignored = 1
let g:fern_git_status#disable_untracked = 1
let g:fern_git_status#disable_submodules = 1

let g:fern#renderer = "devicons"
let g:fern#mark_symbol                       = '●'
let g:fern#renderer#default#collapsed_symbol = '▷ '
let g:fern#renderer#default#expanded_symbol  = '▼ '
let g:fern#renderer#default#leading          = ' '
let g:fern#renderer#default#leaf_symbol      = ' '
let g:fern#renderer#default#root_symbol      = '~ '
highlight GlyphPalette8 guifg=#6b7089

" Fern mappings {{{
function! FernInit() abort
  " fern-custom-actions {{{
  nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -stay<CR>
  nmap <buffer><silent> <Plug>(fern-action-open-and-close)
        \ <Plug>(fern-action-open:select)
        \ <Plug>(fern-close-drawer)
  nmap <buffer><expr>
        \ <Plug>(fern-custom-openAndClose-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open-and-close)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  " }}}

  " Open file
  nmap <buffer> <2-LeftMouse> <Plug>(fern-custom-openAndClose-expand-collapse)
  nmap <buffer> <CR> <Plug>(fern-custom-openAndClose-expand-collapse)
  nmap <buffer> o <Plug>(fern-custom-openAndClose-expand-collapse)
  nmap <buffer> O <Plug>(fern-action-open:tabedit)
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> e <Plug>(fern-action-open:edit)
  nmap <buffer> go <Plug>(fern-action-open:edit)<C-w>p
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> gs <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> gv <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer> E <Plug>(fern-action-open:side)
  nmap <buffer> S <Plug>(fern-action-open:system)

  " Mark file & folders
  nmap <buffer> m <Plug>(fern-action-mark:toggle)
  vmap <buffer> m <Plug>(fern-action-mark:toggle)
  nmap <buffer> Q <Plug>(fern-action-mark:clear)

  " Create, Delete, Copy, Move, Rename
  nmap <buffer> A <Plug>(fern-action-new-path)
  nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> M <Plug>(fern-action-move)
  nmap <buffer> C <Plug>(fern-action-copy)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> D <Plug>(fern-action-remove)

  " Various instant mappings
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> x <Plug>(fern-action-collapse)
  nmap <buffer> I <Plug>(fern-action-hidden:toggle)
  nmap <buffer> W <Plug>(fern-action-cd)
  nmap <buffer> <BAR> <Plug>(fern-action-zoom)<C-w>=
  nmap <silent> <buffer> q :<C-u>close<CR>
  nmap <buffer> <nowait> < <Plug>(fern-action-leave)
  nmap <buffer> <nowait> - <Plug>(fern-action-leave)
  nmap <buffer> <nowait> > <Plug>(fern-action-enter)

  " nmap <buffer> K <Plug>(fern-action-mark-children:leaf)

endfunction
" }}}
" Disable netrw {{{
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction
" }}}
" fernCursorColor {{{
function! s:fernCursorColor() abort
  " TODO: support list
  if &filetype == 'fern'
    highlight CursorLine guibg=#3E4452
  else
    highlight CursorLine guibg=#2C323C
  endif
endfunction
" }}}

augroup FernEvents
  autocmd!
  autocmd FileType fern call FernInit()
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
  autocmd BufEnter * ++nested call s:hijack_directory()
  autocmd WinEnter,BufWinEnter * call s:fernCursorColor()
augroup END

function! s:smart_path() abort
  if !empty(&buftype) || bufname('%') =~# '^[^:]\+://'
    return fnamemodify('.', ':p')
  endif
  return fnamemodify(expand('%'), ':p:h')
endfunction

function! Try_To_select_last_file(time) abort
  if s:fern_last_file !=# ''
    func! CallBackHandler(timer)
      call search('\v<' . s:fern_last_file . '>')
    endfunc
    let timer = timer_start(a:time, 'CallBackHandler')
  endif
endfunction

function! Before_Try_To_select_last_file() abort
  let s:fern_last_file=expand('%:t')
endfunction

