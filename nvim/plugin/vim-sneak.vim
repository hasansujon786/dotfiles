let g:sneak#label = 1
" case insensitive sneak
let g:sneak#use_ic_scs = 1
" immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
let g:sneak#s_next = 1
let g:sneak#target_labels = ";sdgqklqwertyuiopzxcvbnmfj"
" remap so I can use , and ; with f and t
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;
" Cool prompts
let g:sneak#prompt = '🔎 '

" Change Sneak highlight
highlight Sneak guifg=#282C33 guibg=#E06B74 ctermfg=black ctermbg=cyan
highlight SneakScope guifg=#282C33 guibg=white ctermfg=black ctermbg=white

