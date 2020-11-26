set tabline=%!TabLine()

function! TabLine()
  let s = ''
  let s .= s:tabs()
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  let s .= '%=%#TabLineSp#%999X▎%#TabEnd#%@OpenFern@ %-6.10{fnamemodify(getcwd(), ":t")[0:9]} %X'
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
    let tabs .= tab_nr == tabpagenr() ?  '%#TabLineSelSp#▎%#TabLineSel#' :  '%#TabLineSp#▎%#TabLine#'
    " the label
    let tabs .= s:isTurncate(tab_nr) ? '%{TabShortLabel('.tab_nr.')}' : '%{TabLongLabel('.tab_nr.')}'
    let close_tab = '%'.tab_nr.'X %X '
    let tabs .= s:isTurncate(tab_nr) ? '' : IsTabWinModified(tab_nr) ? '●  ' :
          \ (tabpagenr('$') == 1 ? '%#TabLineSelDel#'.close_tab : close_tab)
  endfor
  let tabs .= '%#TabLineSp#▎'
  return tabs
endfunction

function! s:isTurncate(tab_nr)
  let _ = []
  for n in range(1,tabpagenr('$'))
    call add(_, TabLongLabel(n).'  ')
  endfor
  let t_length = len(join(_, ''))
  let cols = &columns - 20
  let tt = tabpagenr('$') - tabpagenr()
  let cc = t_length > cols && a:tab_nr != tabpagenr()

  if (tt >= 2)
    return cc && a:tab_nr != tabpagenr() + 1 && a:tab_nr != tabpagenr() + 2
  elseif (tt == 1)
    return cc && a:tab_nr != tabpagenr() + 1 && a:tab_nr != tabpagenr() - 1
  elseif (tt == 0)
    return cc && a:tab_nr != tabpagenr() - 1 && a:tab_nr != tabpagenr() - 2
  endif
endfunction

" barbar.vim #1c1f24

hi TabLine        guibg=#2C323C guifg=#5C6370
hi TabLineSp      guibg=#2C323C guifg=#4B5263
hi TabLineFill    guibg=#2C323C guifg=#5C6370
hi TabLineSel     guibg=#282C34 guifg=#dddddd
hi TabLineSelMod  guibg=#282C34 guifg=#D19A66
hi TabLineSelSp   guibg=#282C34 guifg=#61AFEF
hi TabLineSelDel  guibg=#282C34 guifg=#5C6370

" hi TabLineFill cleared

" Now the TabLongLabel() function is called for each tab page to get its label. >
function! TabShortLabel(tab_nr)
  let buflist = tabpagebuflist(a:tab_nr)
  let winnr = tabpagewinnr(a:tab_nr)
  let fname = fnamemodify(bufname(buflist[winnr - 1]), ":t")
  " if (fname == '') | let fname = '[No Name]' | endif
  " 2 spaces is needed for better transition
  let label = ' '.nerdfont#find(fname).' '.a:tab_nr.'  '
  return label
endfunction

function! TabLongLabel(tab_nr)
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
