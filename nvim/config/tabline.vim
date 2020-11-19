set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " select the separator highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSelSp#'
      let s .= '▎'
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLineSp#'
      let s .= '▎'
      let s .= '%#TabLine#'
    endif

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineSpLast#'
  let s .= '▎'
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  " if tabpagenr('$') > 1
  "   let s .= '%=%#TabLine#%999X  '
  " endif

  " let s .= '%=%#TabLineSp#%999X▎%#TabEnd#  %{fnamemodify(getcwd(), ":t")} '
  return s
endfunction
" barbar.vim #1c1f24

hi TabLine        guibg=#2C323C guifg=#5C6370
hi TabLineSp      guibg=#2C323C guifg=#4B5263
hi TabLineSpLast  guibg=#2C323C guifg=#4B5263

hi TabLineFill    guibg=#2C323C guifg=#5C6370
" hi TabEnd         guibg=#2C323C guifg=#ABB2BF

hi TabLineSel     guibg=#282C34 guifg=#dddddd
hi TabLineSelSp   guibg=#282C34 guifg=#61AFEF

" hi TabLineFill cleared

" Now the MyTabLabel() function is called for each tab page to get its label. >
function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let fname = fnamemodify(bufname(buflist[winnr - 1]), ":t")
  if (fname == '')
    let fname = '[No Name]'
  endif
  let label = nerdfont#find(fname).' '.fname

  " get label padding
  let pad = ''
  if(len(label) < 22)
    let need_pad = []
    let pad_nr = (22 - len(label)) / 2
    for i in range(pad_nr)
      call add(need_pad, '')
    endfor
    let pad = join(need_pad, ' ')
  endif

  return pad.label.pad
endfunction
