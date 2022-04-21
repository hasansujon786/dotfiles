
function s:close_neogit() abort
  let winCount = tabpagewinnr(tabpagenr(), '$')
  if winCount > 1
    only
  endif

  let tabpageCount = tabpagenr('$')
  if tabpageCount > 1
    tabclose
  else
    bdelete!
  endif
endfunction

function s:map(...) abort
  nmap <buffer> <silent> q :call <SID>close_neogit()<CR>
endfunction

call timer_start(100, funcref('s:map'))
