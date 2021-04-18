let s:hopper_file = getcwd().'/pf.hopper'

function pfhopper#open() abort
  " TODO: remove Fedit file from buflisted
  exec 'Fedit '.s:hopper_file

  nnoremap <silent> <buffer> <CR> :call <SID>hop('edit')<CR>
  nnoremap <silent> <buffer> q    :close<CR>
  nnoremap <silent> <buffer> l    :call <SID>hop('edit')<CR>
  nnoremap <silent> <buffer> t    :call <SID>hop('tabnew')<CR>
  nnoremap <silent> <buffer> s    :call <SID>hop('split')<CR>
  nnoremap <silent> <buffer> v    :call <SID>hop('vsplit')<CR>
endfunction

function s:hop(open_cmd) abort
  let @f = expand('<cWORD>')
  close
  exec a:open_cmd.' '. @f
endfunction

function pfhopper#add_to_hopper_file() abort
  let fname = expand('%:.')
  if(fname == '') | return _#echoError('No file name') | endif

  call _#Echo(['TextInfo', 'Hopper new file:'], '“'.fname.'”')
  call s:write_list(s:hopper_file, fname)
endfunction

function s:write_list(fpath, line) abort
  call system('print "'.a:line.'" >> '.a:fpath)
endfunction

