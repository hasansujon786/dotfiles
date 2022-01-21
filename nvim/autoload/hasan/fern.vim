let s:last_file = ''
let s:alternate_file = ''

function! s:save_last_file()
  if &ft != 'fern'
    let current_file = expand('%:p')
    let alternate_file = expand('#:p')
    let s:last_file = filereadable(current_file) ? current_file : ''
    let s:alternate_file = filereadable(alternate_file) ? alternate_file : s:alternate_file
  endif
endfunction

function! hasan#fern#edit_alternate() abort
  let alternate_is_fern_node = expand('#') =~# '^[^:]\+://'
  if (alternate_is_fern_node && s:last_file != '')
    let openfile = s:last_file == expand('%') ? s:alternate_file : s:last_file
    exec 'e '.openfile
  else
    try
      exe "normal! \<c-^>"
    catch
      echo 'E23: No alternate file'
    endtry
  endif
endfunction

function! hasan#fern#drawer_toggle(reveal) abort
  call s:save_last_file()

  if expand('%:t') != '' && a:reveal
    Fern . -drawer -toggle -reveal=%
  else
    Fern . -drawer -toggle
  endif
  " wincmd =
endfunction

" function! hasan#fern#smart_path(drawer)
function! hasan#fern#open_dir()
  if &ft == 'fern' | return | endif
  call s:save_last_file()

  let fname=fnamemodify(s:last_file, ':t')
  exec 'Fern %:h -drawer -wait | FernReveal '.fname.' -wait'
endfunction

function! hasan#fern#vinager()
  call s:save_last_file()
  exec 'Fern %:h -wait | FernReveal #:t -wait'
endfunction

function! hasan#fern#hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction

" Fern mappings {{{
function! hasan#fern#focus_last_file()
  if &ft != 'fern' | return | endif

  if fnamemodify(getcwd(), ':t').';$' == fnamemodify(expand('%'), ':t')
    exec 'FernReveal '.s:last_file.' -wait'
  else
    exec 'FernReveal '.fnamemodify(s:last_file, ':t').' -wait'
  endif
endfunction

" node = {
"  __processing = 0,
"  _path = "C:\\Users\\hasan\\dotfiles\\nvim\\autoload\\hasan\\coc.vim",
"  badge = "",
"  bufname = "C:\\Users\\hasan\\dotfiles\\nvim\\autoload\\hasan\\coc.vim",
"  concealed = vim.empty_dict(),
"  hidden = 0,
"  label = "coc.vim",
"  name = "coc.vim",
"  status = 0
" }
function! hasan#fern#fern_explorer_open() abort
  let helper = fern#helper#new()
  let node = helper.sync.get_cursor_node()
  let path = fnamemodify(node._path, ':gs?\\\?\?')
  execute('silent !explorer '. path)
endfunction

function! hasan#fern#edit_fern_alternate() abort
  if (&ft == 'fern' && s:last_file != '')
    execute('e '.s:last_file)
  endif
endfunction

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
  " Immediately delete
  nmap <buffer>
        \ <Plug>(immediately-trash)
        \ <Plug>(fern-action-trash=)y<CR>

  nmap <silent> <Plug>(fern-custom-open:system) :call hasan#fern#fern_explorer_open()<CR>
  " }}}

  " Open file
  nmap <buffer> <2-LeftMouse> <Plug>(fern-custom-openAndClose-expand-collapse)
  nmap <buffer> o <Plug>(fern-custom-openAndClose-expand-collapse)
  nmap <buffer> p <Plug>(fern-action-open:edit)<C-w>p
  nmap <buffer> i <Plug>(fern-action-open:edit)
  nmap <buffer> e <Plug>(fern-action-open:edit)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer>gs <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer> S <Plug>(fern-action-open:above)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer>gv <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer> V <Plug>(fern-action-open:side)
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> O <Plug>(fern-custom-open:system)
  " nmap <buffer> O <Plug>(fern-action-open:tabedit)

  " Create, Delete, Copy, Move, Rename
  nmap <buffer> y <Plug>(fern-action-yank:path)
  nmap <buffer> Y <Plug>(fern-action-yank:label)
  nmap <buffer> A <Plug>(fern-action-new-path)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> <c-n> <Plug>(fern-action-new-file)
  nmap <buffer> <C-x> <Plug>(fern-action-move)
  nmap <buffer> <C-c> <Plug>(fern-action-copy)
  nmap <buffer> <C-r> <Plug>(fern-action-rename)
  nmap <buffer> <F2>  <Plug>(fern-action-move)
  nmap <buffer> <delete> <Plug>(immediately-trash)

  " Various instant mappings
  nmap <buffer> m <Plug>(fern-action-mark:toggle)
  nmap <buffer> U <Plug>(fern-action-mark:clear)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> x <Plug>(fern-action-collapse)
  nmap <buffer> u <Plug>(fern-action-focus:parent)
  nmap <buffer> I <Plug>(fern-action-hidden:toggle)
  nmap <buffer> W <Plug>(fern-action-cd)
  nmap <buffer> q <C-w>c
  nmap <buffer><nowait> l <Plug>(fern-custom-openAndClose-enter)
  nmap <buffer><nowait> h <Plug>(fern-action-leave)
  nmap <buffer><nowait> - <Plug>(fern-action-leave)
  nmap <buffer><nowait> <CR> <Plug>(fern-custom-openAndClose-enter)
  nmap <buffer><nowait><Bar> <Plug>(fern-action-zoom:reset)
  nmap <silent><buffer> f :call hasan#fern#focus_last_file()<CR>
  nmap <silent><buffer> <BS> :call hasan#fern#edit_fern_alternate()<CR>
endfunction

