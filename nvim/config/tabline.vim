set tabline=%!tabline#_layout()
let g:tabline = {
      \ 'tabs_can_fit': 4,
      \ 'tab_lenght': 26,
      \ 'left_trunc_marker': '',
      \ 'right_trunc_marker': '',
      \}

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
hi TabCountButton guifg=#ABB2BF

" hi TabLineFill cleared

