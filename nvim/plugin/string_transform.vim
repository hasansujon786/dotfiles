nmap <silent><Plug>(snake_case_operator)  :set opfunc=string_transform#_opfunc<CR>"="snake_case"<CR>g@
vmap <silent><Plug>(snake_case_operator)  :<C-U>call string_transform#_opfunc(visualmode(), "snake_case")<CR>
nmap <silent><Plug>(kebab_case_operator)  :set opfunc=string_transform#_opfunc<CR>"="kebab_case"<CR>g@
vmap <silent><Plug>(kebab_case_operator)  :<C-U>call string_transform#_opfunc(visualmode(), "kebab_case")<CR>
nmap <silent><Plug>(start_case_operator)  :set opfunc=string_transform#_opfunc<CR>"="start_case"<CR>g@
vmap <silent><Plug>(start_case_operator)  :<C-U>call string_transform#_opfunc(visualmode(), "start_case")<CR>
nmap <silent><Plug>(camel_case_operator)  :set opfunc=string_transform#_opfunc<CR>"="camel_case"<CR>g@
vmap <silent><Plug>(camel_case_operator)  :<C-U>call string_transform#_opfunc(visualmode(), "camel_case")<CR>
nmap <silent><Plug>(upper_camel_case_operator)  :set opfunc=string_transform#_opfunc<CR>"="upper_camel_case"<CR>g@
vmap <silent><Plug>(upper_camel_case_operator)  :<C-U>call string_transform#_opfunc(visualmode(), "upper_camel_case")<CR>
