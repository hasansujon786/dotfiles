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

command! ColorVRefrest exe 'ColorVMid' | call s:colorVlocalMaps([])
function! s:colorVlocalMaps(...)
  noremap <silent><buffer> r :ColorVRefrest<CR>
  noremap <silent><buffer> <C-l> :ColorVRefrest<CR><C-l>
endfunction

augroup ColorV
  autocmd BufEnter _ColorV_* call timer_start(10, function('s:colorVlocalMaps'))
augroup END
