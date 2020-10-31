
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" type                                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! _#_isNumber(val)
  return type(a:val) == v:t_number
endfunction

function! _#_isFloat(val)
  return type(a:val) == v:t_float
endfunction

function! _#_isString(val)
  return type(a:val) == v:t_string
endfunction

function! _#_isFunc(val)
  return type(a:val) == v:t_func
endfunction

function! _#_isList(val)
  return type(a:val) == v:t_list
endfunction

function! _#_isDict(val)
  return type(a:val) == v:t_dict
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" echo                                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" !::exe [So]

" command! -bar -bang -nargs=* Log      redraw | call _#_Info(<args>)
" command! -bar -bang -nargs=* Debug    redraw | call _#_Debug(<args>)
" command! -bar -bang -nargs=* Warn     redraw | call _#_Warn(<args>)
" command! -bar -bang -nargs=* Error    redraw | call _#_Error(<args>)
" command! -bar -bang -nargs=* Success  redraw | call _#_Success(<args>)
" command! -bar -bang -nargs=* Info     redraw | call _#_Info(<args>)

fu! Echon(...) " {{{
  echon join(a:000)
endfu " }}}
fu! EchoHL(hlgroup, ...) " {{{
  exe ':echohl ' . a:hlgroup
  echo join(a:000)
  exe ':echohl None'
endfu " }}}
fu! EchonHL(hlgroup, ...) " {{{
  exe ':echohl ' . a:hlgroup
  echon join(a:000)
endfu " }}}
fu! Echom(...) " {{{
  echom join(a:000)
endfu " }}}

fu! Log(hl, ...)
  silent! echom string(a:000)
  let args = a:000
  if (a:0 == 1 && _#_isList(a:1))
    let args = a:1
  end

  for idx in range(len(args))
    if _#_isString(args[idx])
      call EchonHL(a:hl, args[idx])
    else
      " @todo: fix this
      call pp#dump( args[idx] )
    end
    echon ' '
  endfor
  echohl None
endfu
fu! _#_Debug (...)
  call Log('Debug', a:000)
endfu
fu! _#_Warn (...)
  call Log('WarningMsg', a:000)
endfu
fu! _#_Error (...)
  call Log('ErrorMsg', a:000)
endfu
fu! _#_Info (...)
  call Log('TextInfo', a:000)
endfu
fu! _#_Success (...)
  call call('Log', ['TextSuccess'] + a:000)
endfu


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mics                                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! _#_Insertion(cmd)
  let g:last_insertion = a:cmd
  put =g:last_insertion
endfunc
