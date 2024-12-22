setl shiftwidth=2 tabstop=2 softtabstop=2
setl conceallevel=2 concealcursor=nc

xnoremap <buffer> - <Esc><cmd>lua require('hasan.org').create_link()<CR>
nnoremap <buffer> cic   <cmd>lua require('orgmode').action('org_mappings.toggle_checkbox')<CR>
nnoremap <buffer> <C-q> <cmd>lua require('orgmode').action('org_mappings.toggle_checkbox')<CR>
nnoremap <buffer> <A-space> <cmd>lua require('orgmode').action('org_mappings.toggle_checkbox')<CR>


