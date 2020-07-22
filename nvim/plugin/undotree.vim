Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

let g:undotree_WindowLayout = 2
let g:undotree_DiffAutoOpen = 0
" let g:undotree_DiffpanelHeight = 10
nnoremap <silent> <C-F5> :UndotreeToggle<cr>
