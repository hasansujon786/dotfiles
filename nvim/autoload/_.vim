
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" type                                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! _#isNumber(val)
  return type(a:val) == v:t_number
endfunction

function! _#isFloat(val)
  return type(a:val) == v:t_float
endfunction

function! _#isString(val)
  return type(a:val) == v:t_string
endfunction

function! _#isFunc(val)
  return type(a:val) == v:t_func
endfunction

function! _#isList(val)
  return type(a:val) == v:t_list
endfunction

function! _#isDict(val)
  return type(a:val) == v:t_dict
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" echo                                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" !::exe [So]

" call _#Echo(['WarningMsg', 'Couldn’t find definition for'], '“'.str.'”')
function! _#Echo(...)
  echo ''
  let args = a:000
  for idx in range(len(args))
    if _#isString(args[idx])
      echon args[idx]
    else
      execute("echohl ".args[idx][0]." | echon '".args[idx][1]."' | echohl None")
    end
    echon ' '
  endfor
  echohl None
endfunction
fu! _#echoDebug (...)
  call _#Echo(['Debug', join(a:000, ' ')])
endfu
fu! _#echoWarn (...)
  call _#Echo(['WarningMsg', join(a:000, ' ')])
endfu
fu! _#echoError (...)
  call _#Echo(['ErrorMsg', join(a:000, ' ')])
endfu
fu! _#echoInfo (...)
  call _#Echo(['TextInfo', join(a:000, ' ')])
endfu
fu! _#echoSuccess (...)
  call _#Echo(['TextSuccess', join(a:000, ' ')])
endfu


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mics                                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! _#Insertion(cmd)
  let g:last_insertion = a:cmd
  put =g:last_insertion
endfunc

function! _#print_to_float(var_name)
  if(!exists('b:Fedit_bufnr'))
    call hasan#float#_createCenteredFloatingWindow(0)
  endif

  if (_#isDict(a:var_name))
    let keys = keys(a:var_name)
    let values = values(a:var_name)
    for idx in range(len(a:var_name))
      put =keys[idx].' : '.values[idx]
    endfor
  else
    put =a:var_name
  endif
endfunc


