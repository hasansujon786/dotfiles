" Open current file directory into the buffer
nnoremap <silent> <Plug>(my-fern-vinager) :call hasan#fern#smart_path(0)<CR>
nnoremap <silent> <Plug>(my-fern-cdir) :call hasan#fern#smart_path(1)<CR>
nnoremap <silent> <Plug>(my-fern-t&r) :call hasan#fern#drawer_toggle(1)<CR>
nnoremap <silent> <Plug>(my-fern-toggle) :call hasan#fern#drawer_toggle(0)<CR>
nmap - <Plug>(my-fern-vinager)

let g:fern#drawer_width = 35
let g:fern#keepalt_on_edit = 1
let g:fern#default_hidden = 1
let g:fern#disable_default_mappings = 1
let g:fern#disable_drawer_smart_quit = 1
let g:fern_git_status#disable_ignored = 1
let g:fern_git_status#disable_untracked = 1
let g:fern_git_status#disable_submodules = 1
let g:fern#default_exclude = '\.git\|node_modules'
let g:fern#hide_cursor = 1
let g:fern#renderer = 'nerdfont'
let g:fern#mark_symbol                       = '●'
let g:fern#renderer#default#collapsed_symbol = '▷ '
let g:fern#renderer#default#expanded_symbol  = '▼ '
let g:fern#renderer#default#leading          = ' '
let g:fern#renderer#default#leaf_symbol      = ' '
let g:fern#renderer#default#root_symbol      = '~ '
" let g:nerdfont#path#extension#customs = {
"       \ 'vue': 'V',
"       \}

