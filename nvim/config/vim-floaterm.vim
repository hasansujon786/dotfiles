""" Configs
let g:floaterm_width = 0.98
let g:floaterm_height = 0.9
let g:floaterm_title = '$1/$2'
""" Keymaps
let g:floaterm_keymap_new    = '<C-\>c'
let g:floaterm_keymap_prev   = '<C-\>p'
let g:floaterm_keymap_next   = '<C-\>n'
let g:floaterm_keymap_kill   = '<C-\>x'
let g:floaterm_keymap_toggle = '<C-\><C-\>'
nnoremap <silent> <C-\><C-\> :FloatermToggle<CR>
nnoremap <silent> <C-\>c :FloatermNew<CR>

