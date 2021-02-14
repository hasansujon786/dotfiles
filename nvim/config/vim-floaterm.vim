""" Configs
let g:floaterm_width = 0.98
let g:floaterm_height = 0.9
let g:floaterm_title = '─$1/$2'
let g:floaterm_borderchars = '─│─│╭╮╯╰'
let g:floaterm_autoclose = 1
let g:floaterm_autohide = 2
""" Keymaps
let g:floaterm_keymap_new    = '<C-\>c'
let g:floaterm_keymap_prev   = '<C-\>p'
let g:floaterm_keymap_next   = '<C-\>n'
let g:floaterm_keymap_kill   = '<C-\>x'
let g:floaterm_keymap_toggle = '<C-\><C-\>'
nnoremap <silent> <C-\><C-\> :FloatermToggle<CR>
nnoremap <silent> <C-\>c :FloatermNew<CR>
nmap <silent> ]t :FloatermToggle<CR><C-\><C-n>
nmap <silent> [t :FloatermToggle<CR><C-\><C-n>

