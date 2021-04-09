let g:colorv_preview_ftype=''
" let g:colorv_has_python=0

function! _colorVConvertTo(colorType)
  exe 'ColorVEditTo '.a:colorType
  exe 'nmap <silent><Plug>(colorVconvertTo) :call _colorVConvertTo("'.a:colorType.'")<CR>'

  let s:timer = timer_start(10, function('s:quitBuffer'))
endfunction
function! s:quitBuffer(...) abort
  normal q
  call repeat#set("\<Plug>(colorVconvertTo)")
endfunction

