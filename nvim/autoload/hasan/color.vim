function hasan#color#load_custom_highlight() abort
  hi TextInfo           ctermfg=38  guifg=#56B6C2
  hi TextSuccess        ctermfg=39  guifg=#61AFEF
  hi Debug              ctermfg=180 guifg=#E5C07B
  hi CursorLineDefault  ctermbg=236 guibg=#2C323C
  hi CursorLineFocus    ctermbg=237 guibg=#3E4452
  hi Notification       guibg=#3E4452 guifg=#E5C07B
  hi VertSplit          guifg=#5c6370 guibg=#363d49
  hi Fedit              guibg=#282C34
  hi FeditBorder        guibg=#282C34 guifg=#5C6370
  " hi NonText            ctermfg=180 guifg=#E5C07B
  " hi SpecialKey         ctermfg=180 guifg=#E5C07B
  " Highlighting same symbols in the buffer at the current cursor position.
  hi CocHighlightText ctermbg=gray guibg=#3B4048

  " gitgutter & signnify
  hi SignifySignAdd       ctermfg=114 guifg=#496A2F
  hi SignifySignChange    ctermfg=180 guifg=#805C19
  hi SignifySignDelete    ctermfg=204 guifg=#931F29

endfunction
