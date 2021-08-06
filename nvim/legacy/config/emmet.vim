" let g:user_emmet_install_global = 0
" cst<
let g:user_emmet_leader_key = '<C-c>'
imap <C-c> <nop>
nmap <C-c><C-c> <plug>(emmet-expand-abbr)
imap <C-c><C-c> <plug>(emmet-expand-abbr)
nmap <C-c>w V%<C-c>,
vmap <C-c>w <C-c>,
nmap <C-c>u cst<

" imap   <C-y>;   <plug>(emmet-expand-word)
" imap   <C-y>u   <plug>(emmet-update-tag)
" imap   <C-y>d   <plug>(emmet-balance-tag-inward)
" imap   <C-y>D   <plug>(emmet-balance-tag-outward)
" imap   <C-y>n   <plug>(emmet-move-next)
" imap   <C-y>N   <plug>(emmet-move-prev)
" imap   <C-y>i   <plug>(emmet-image-size)
" imap   <C-y>/   <plug>(emmet-toggle-comment)
" imap   <C-y>j   <plug>(emmet-split-join-tag)
" imap   <C-y>k   <plug>(emmet-remove-tag)
" imap   <C-y>a   <plug>(emmet-anchorize-url)
" imap   <C-y>A   <plug>(emmet-anchorize-summary)
" imap   <C-y>m   <plug>(emmet-merge-lines)
" imap   <C-y>c   <plug>(emmet-code-pretty)
