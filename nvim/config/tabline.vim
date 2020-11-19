set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for tab_nr in range(1,tabpagenr('$'))
    " set the tab page number (for mouse clicks)
    let s .= '%' . (tab_nr) . 'T'
    " select the separator highlighting
    let s .= tab_nr == tabpagenr() ?  '%#TabLineSelSp#▎%#TabLineSel#' :  '%#TabLineSp#▎%#TabLine#'

    " the label is made by MyTabLabel()
    let s .= '%{MyTabLabel('.(tab_nr).')}'
    let s .= IsTabWinModified(tab_nr) ? '●' : tab_nr == tabpagenr() ? '%999X' :  ''
    let s .= '  '
  endfo

  let s .= '%#TabLineSp#▎'
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " let s .= '%=%#TabLineSp#%999X▎%#TabEnd#  %{fnamemodify(getcwd(), ":t")} '
  return s
endfunction
" barbar.vim #1c1f24

hi TabLine        guibg=#2C323C guifg=#5C6370
hi TabLineSp      guibg=#2C323C guifg=#4B5263
hi TabLineFill    guibg=#2C323C guifg=#5C6370
hi TabLineSel     guibg=#282C34 guifg=#dddddd
hi TabLineSelMod  guibg=#282C34 guifg=#D19A66
hi TabLineSelSp   guibg=#282C34 guifg=#61AFEF

" hi TabLineFill cleared

" Now the MyTabLabel() function is called for each tab page to get its label. >
function! MyTabLabel(tab_nr)
  let buflist = tabpagebuflist(a:tab_nr)
  let winnr = tabpagewinnr(a:tab_nr)
  let fname = fnamemodify(bufname(buflist[winnr - 1]), ":t")
  if (fname == '') | let fname = '[No Name]' | endif
  " 2 spaces is needed for better transition
  let label = nerdfont#find(fname).'  '.fname

  " get label padding
  let pad = '  '
  if(len(label) < 22)
    let need_pad = []
    let pad_nr = (22 - len(label)) / 2
    for i in range(pad_nr)
      call add(need_pad, '')
    endfor
    let pad = join(need_pad, ' ')
    if (len(pad) < 2) | let pad = '  ' | endif
  endif

  return pad.label.pad
endfunction

function! IsTabWinModified(tab_nr)
  let buflist = tabpagebuflist(a:tab_nr)
  let winnr = tabpagewinnr(a:tab_nr)
  return getbufvar(buflist[winnr - 1], '&modified')
endfunction
