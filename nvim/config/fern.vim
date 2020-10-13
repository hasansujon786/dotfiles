" Open current file directory into the buffer
nnoremap <silent> - :
      \call hasan#fern#before_Try_To_select_last_file()<CR>
      \:Fern <C-r>=hasan#fern#smart_path()<CR> -wait<CR>
      \:call hasan#fern#try_To_select_last_file()<CR>

command! FernCurDirDrawer
\  call hasan#fern#before_Try_To_select_last_file()
\| Fern %:h -drawer -wait
\| call hasan#fern#try_To_select_last_file()


let g:fern#drawer_width = 40
let g:fern#keepalt_on_edit = 1
let g:fern#default_hidden = 1
let g:fern#disable_default_mappings = 1
let g:fern#disable_drawer_smart_quit = 1
let g:fern_git_status#disable_ignored = 1
let g:fern_git_status#disable_untracked = 1
let g:fern_git_status#disable_submodules = 1
let g:fern#default_exclude = '\.git\|node_modules'
" let g:fern#smart_cursor = 'hide'
let g:fern#renderer = 'nerdfont'
let g:fern#mark_symbol                       = '●'
let g:fern#renderer#default#collapsed_symbol = '▷ '
let g:fern#renderer#default#expanded_symbol  = '▼ '
let g:fern#renderer#default#leading          = ' '
let g:fern#renderer#default#leaf_symbol      = ' '
let g:fern#renderer#default#root_symbol      = '~ '
" Folder color
highlight GlyphPalette8 guifg=#6b7089

