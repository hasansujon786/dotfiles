
function s:foo() abort
  let wincount = tabpagewinnr(tabpagenr(), '$')
  if wincount > 1
    only
  endif
  q!
endfunction


function s:map(...) abort
  nmap <buffer> <silent> q :call <SID>foo()<CR>
endfunction

call timer_start(100, funcref('s:map'))
