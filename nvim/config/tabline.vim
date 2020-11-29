set tabline=%!TabLine()
let s:tabs_can_fit = 4
let s:onetab_ln = 22 - 5
let s:label_ln = s:onetab_ln + 2


function! TabLine()
  let s = ''
  let s .= s:tabs()
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  let s.= '%='
  " let s .= '%=%#TabLineSp#%999X▎%#TabEnd#%@OpenFern@ %-6.10{fnamemodify(getcwd(), ":t")[0:9]} %X'
  let s .= tabpagenr('$') > s:tabs_can_fit ? '%#TabCountSp#%#TabCount#' : '%#TabCountAltSp#%#TabCountAlt#'
  let s .= ' %2{tabpagenr()}/%-2{tabpagenr("$")} '
  return s
endfunction

function! OpenFern(...)
  Fern . -reveal=%
endfunction

function! s:tabs()
  let tabs = ''
  for tab_nr in range(1,tabpagenr('$'))
    " set the tab page number (for mouse clicks)
    let tabs .= '%' . (tab_nr) . 'T'
    " select the separator highlighting
    let tabs .= s:isTurncate(tab_nr) ? '': tab_nr == tabpagenr() ?  '%#TabLineSelSp#▎%#TabLineSel#' :  '%#TabLineSp#▎%#TabLine#'
    " the label
    let tabs .= s:isTurncate(tab_nr) ? '' : ' %-'.s:onetab_ln.'{TabLabel('.tab_nr.')}'
    let close_tab = '%'.tab_nr.'X %X '
    let tabs .= s:isTurncate(tab_nr) ? '' : IsTabWinModified(tab_nr) ? '●  ' :
          \ (tabpagenr('$') == 1 ? '%#TabLineSelX#'.close_tab : close_tab)
  endfor
  let tabs .= '%#TabLineSp#▎'
  return tabs
endfunction

function! s:isTurncate(tab_nr)
  let cc = tabpagenr('$') > s:tabs_can_fit && a:tab_nr != tabpagenr()

  if (tabpagenr() == 1)
    return cc && a:tab_nr != tabpagenr() + 1 && a:tab_nr != tabpagenr() + 2 && a:tab_nr != tabpagenr() + 3
  elseif (tabpagenr() == 2)
    return cc && a:tab_nr != tabpagenr() - 1 && a:tab_nr != tabpagenr() + 1 && a:tab_nr != tabpagenr() + 2
  elseif (tabpagenr() == 3)
    return cc && a:tab_nr != tabpagenr() - 2 && a:tab_nr != tabpagenr() - 1 && a:tab_nr != tabpagenr() + 1
  elseif (tabpagenr() >= 4 && tabpagenr() != tabpagenr('$'))
    return cc && a:tab_nr != tabpagenr() - 2 && a:tab_nr != tabpagenr() - 1 && a:tab_nr != tabpagenr() + 1
  elseif (tabpagenr() >= 4 && tabpagenr() == tabpagenr('$'))
    return cc && a:tab_nr != tabpagenr() - 3 && a:tab_nr != tabpagenr() - 2 && a:tab_nr != tabpagenr() - 1
  endif
endfunction

" barbar.vim #1c1f24

hi TabLine        guibg=#2C323C guifg=#5C6370
hi TabLineSp      guibg=#2C323C guifg=#4B5263
hi TabLineFill    guibg=#2C323C guifg=#5C6370
hi TabLineSel     guibg=#282C34 guifg=#dddddd gui=bold

hi TabCount       guibg=#98C379 guifg=#2C323C gui=bold
hi TabCountSp     guibg=#2C323C guifg=#98C379
hi TabCountAlt    guibg=#3E4452 guifg=#ABB2BF
hi TabCountAltSp  guibg=#2C323C guifg=#3E4452

hi TabLineSelSp   guibg=#282C34 guifg=#61AFEF
hi TabLineSelX    guibg=#282C34 guifg=#5C6370

" hi TabLineFill cleared

function! TabLabel(tab_nr)
  let buflist = tabpagebuflist(a:tab_nr)
  let winnr = tabpagewinnr(a:tab_nr)
  let fname = fnamemodify(bufname(buflist[winnr - 1]), ":t")
  if (fname == '') | let fname = '[No Name]' | endif
  let label = nerdfont#find(fname).' '.fname.' '
  if (len(label) > s:label_ln) | let label = label[0:s:label_ln-3].'..' | endif

  return label
endfunction

function! IsTabWinModified(tab_nr)
  let buflist = tabpagebuflist(a:tab_nr)
  let winnr = tabpagewinnr(a:tab_nr)
  return getbufvar(buflist[winnr - 1], '&modified')
endfunction
