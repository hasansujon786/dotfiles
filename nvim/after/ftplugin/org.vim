nmap <buffer> <CR>  <Leader>oo

function! Org_foldtext()
  let line = getline(v:foldstart)
  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth
  let foldedlinecount = (v:foldend-v:foldstart+1)

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2)
  let fillcharcount = windowwidth - len(line)

  return line .''. repeat(" ",fillcharcount)
endfunction

setl foldtext=Org_foldtext()
" setl spell
