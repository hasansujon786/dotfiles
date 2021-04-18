function! s:get_hopper_file() abort
  return '~/.config/pf.hopper/'. fnamemodify(getcwd(), ':t') .'/pf.hopper'
endfunction

function! pfhopper#open() abort
  call hasan#utils#_filereadable_and_create(s:get_hopper_file(), v:true)
  exec 'Fedit! '.s:get_hopper_file()

  if fnamemodify(s:get_hopper_file(), ':t') != 'pf.hopper'
    return _#echoError('Something went wrong')
  endif

  set signcolumn=no
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
  call system('print "'.fname.'" >> '.s:get_hopper_file())
  call _#Echo(['TextInfo', 'Hopper new file:'], '“'.fname.'”')
endfunction

