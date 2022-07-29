function hasan#statusline#searchcount() abort
  if !v:hlsearch
    return ''
  endif
  try
    const count = searchcount({'maxcount': 0, 'timeout': 50})
  catch /^Vim\%((\a\+)\)\=:\%(E486\)\@!/
    return '[?/??]'
  endtry
  return count.total ? count.incomplete ? printf('[%d/??]', count.current) : printf('[%d/%d]', count.current, count.total)  : '[0/0]'
endfunction

