function! hasan#fern#open_drawer() abort
  if expand('%:t') == ''
    Fern . -drawer -toggle | wincmd =
  else
    Fern . -drawer -toggle -reveal=% | wincmd =
  endif
endfunction

function! hasan#fern#smart_path(drawer)
  if !empty(&buftype) || bufname('%') =~# '^[^:]\+://'
    Fern .
  else
    let fern_last_file=expand('%:t')
    if a:drawer | Fern %:h -drawer -wait | else | Fern %:h -wait | endif
    if fern_last_file !=# '' | call search('\v<' . fern_last_file . '>') | endif
  endif
endfunction

" Fern mappings {{{
function! hasan#fern#FernInit() abort
  " fern-custom-actions {{{
  nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -stay<CR>
  nmap <buffer><silent> <Plug>(fern-action-open-and-close) <Plug>(fern-action-open:select)<Plug>(fern-close-drawer)
  nmap <buffer><expr>
        \ <Plug>(fern-custom-openAndClose-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open-and-close)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  nmap <buffer><expr>
        \ <Plug>(fern-custom-openAndClose-enter)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open-and-close)",
        \   "\<Plug>(fern-action-enter)",
        \ )

  " }}}

  " Open file
  nmap <buffer> <2-LeftMouse> <Plug>(fern-custom-openAndClose-expand-collapse)
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
  nmap <buffer> u <Plug>(fern-action-mark:clear)

  " Create, Delete, Copy, Move, Rename
  nmap <buffer> A <Plug>(fern-action-new-path)
  " nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> M <Plug>(fern-action-move)
  nmap <buffer> R <Plug>(fern-action-move)
  nmap <buffer> C <Plug>(fern-action-copy)
  nmap <buffer> <f2> <Plug>(fern-action-rename)
  nmap <buffer> DD <Plug>(fern-action-remove)

  " Various instant mappings
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> x <Plug>(fern-action-collapse)
  nmap <buffer> I <Plug>(fern-action-hidden:toggle)
  nmap <buffer> W <Plug>(fern-action-cd)
  nmap <buffer> B <Plug>(fern-action-save-as-bookmark)
  nmap <buffer> q <C-w>c
  nmap <buffer> <BAR> <Plug>(fern-action-zoom)<C-w>=
  nmap <buffer><nowait> <CR> <Plug>(fern-custom-openAndClose-enter)
  nmap <buffer><nowait> l <Plug>(fern-custom-openAndClose-enter)
  nmap <buffer><nowait> h <Plug>(fern-action-leave)
  nmap <buffer><nowait> - <Plug>(fern-action-leave)
  " nmap <buffer> K <Plug>(fern-action-mark-children:leaf)

  " Open bookmark:///
  nnoremap <buffer><silent>
        \ <Plug>(fern-my-enter-bookmark)
        \ :<C-u>Fern bookmark:///<CR>
  nmap <buffer><expr><silent>
        \ <Tab>
        \ fern#smart#scheme(
        \   "\<Plug>(fern-my-enter-bookmark)",
        \   {
        \     'bookmark': "\<C-^>",
        \   },
        \ )
endfunction
" }}}

