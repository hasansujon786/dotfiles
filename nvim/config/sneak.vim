let g:sneak#label = 1
" case insensitive sneak
let g:sneak#use_ic_scs = 1
" immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
" let g:sneak#s_next = 1
let g:sneak#target_labels = ";wertyuopzbnmfLGKHWERTYUIQOPZBNMFJ0123456789"
" Cool prompts
let g:sneak#prompt = '  '

" remap so I can use , and ; with f and t
nmap <expr> ; sneak#is_sneaking() ? '<Plug>Sneak_;' : ';'
nmap <expr> , sneak#is_sneaking() ? '<Plug>Sneak_,' : ','
" Repeat the last Sneak
nmap gs s<CR>
nmap gS S<CR>

" Change Sneak highlight
hi Sneak      gui=bold guibg=#E06B74 guifg=#282C33
hi SneakScope gui=bold guibg=#61AFEF
autocmd ColorScheme * hi Sneak gui=bold guibg=#E06B74 guifg=#282C33 | hi SneakScope gui=bold guibg=#61AFEF
