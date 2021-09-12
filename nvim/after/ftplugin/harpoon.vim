function! s:hop(open_cmd) abort
  normal! 0w
  let filepath = expand('<cWORD>')
  close
  exec a:open_cmd.' '. filepath
endfunction

nnoremap <silent> <buffer> l :call <SID>hop('edit')<CR>
nnoremap <silent> <buffer> t :call <SID>hop('tabnew')<CR>
nnoremap <silent> <buffer> s :call <SID>hop('split')<CR>
nnoremap <silent> <buffer> v :call <SID>hop('vsplit')<CR>
nnoremap <silent> <buffer> f :call <SID>hop('Fedit')<CR>
nnoremap <silent> <buffer> q :wq<CR>
