function! s:get_hopper_file() abort
  return fnamemodify('~/.config/pf.hopper/'. fnamemodify(getcwd(), ':t') .'/pf.hopper', ":p")
endfunction

function! pfhopper#open() abort
  let hopper_file = s:get_hopper_file()
  let exists = hasan#utils#_filereadable_and_create(hopper_file, v:true)
  if !exists | return 0 | endif

  call hasan#float#_fedit(hopper_file, 1, {
        \ 'window': {'width': 0.7, 'height': 0.5},
        \ 'bufname': fnamemodify(getcwd(), ':~'),
        \})

  nnoremap <silent> <buffer> <CR> :call <SID>hop('edit')<CR>
  nnoremap <silent> <buffer> l :call <SID>hop('edit')<CR>
  nnoremap <silent> <buffer> t :call <SID>hop('tabnew')<CR>
  nnoremap <silent> <buffer> s :call <SID>hop('split')<CR>
  nnoremap <silent> <buffer> v :call <SID>hop('vsplit')<CR>
  nnoremap <silent> <buffer> f :call <SID>hop('Fedit')<CR>
endfunction

function! s:hop(open_cmd) abort
  let @f = expand('<cWORD>')
  close
  exec a:open_cmd.' '. @f
endfunction

function! pfhopper#add_to_hopper_file() abort
  let fname = expand('%:.')
  if(fname == '') | return _#echoError('No file name') | endif

  call hasan#utils#_filereadable_and_create(s:get_hopper_file(), v:true)
  execute 'redir! >> '.s:get_hopper_file()
  echo fname
  redir END
  " call system('print "'.fname.'" >> '.s:get_hopper_file())
  " call _#Echo(['TextInfo', 'Hopper new file:'], '“'.fname.'”')
endfunction

function! pfhopper#fzf_add_to_hopper_file(lines) abort
  call hasan#utils#_filereadable_and_create(s:get_hopper_file(), v:true)
  call system('print "" >> '.s:get_hopper_file())
  for line in a:lines
    call system('print "'.line.'" >> '.s:get_hopper_file())
  endfor
endfunction

