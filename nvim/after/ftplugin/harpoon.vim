function! s:hop(open_cmd) abort
  normal! 0w
  let filepath = expand('<cWORD>')
  close
  exec a:open_cmd.' '. filepath
endfunction

nnoremap <silent> <buffer> o <cmd>call <SID>hop('edit')<CR>
nnoremap <silent> <buffer> l <cmd>call <SID>hop('edit')<CR>
nnoremap <silent> <buffer> t <cmd>call <SID>hop('tabnew')<CR>
nnoremap <silent> <buffer> s <cmd>call <SID>hop('split')<CR>
nnoremap <silent> <buffer> v <cmd>call <SID>hop('vsplit')<CR>
nnoremap <silent> <buffer> f <cmd>call <SID>hop('Fedit')<CR>

for key in [1,2,3,4,5,6,7,8,9]
  exec 'nnoremap <silent> <buffer> '.key.' <cmd>'.key.'<CR><cmd>call <SID>hop("edit")<CR>'
endfor
