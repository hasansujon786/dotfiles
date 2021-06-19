function hasan#highlight#load_custom_highlight() abort
  hi TextInfo           ctermfg=38  guifg=#56B6C2
  hi TextSuccess        ctermfg=39  guifg=#61AFEF
  hi Debug              ctermfg=180 guifg=#E5C07B
  hi CursorLineDefault  ctermbg=236 guibg=#2C323C
  hi CursorLineFocus    ctermbg=237 guibg=#3E4452
  hi Notification       guibg=#3E4452 guifg=#E5C07B
  hi VertSplit          guifg=#4D5666 guibg=#363d49
  hi Fedit              guibg=#282C34
  hi FeditBorder        guibg=#282C34 guifg=#5C6370
  hi! link TelescopeBorder FeditBorder
  " hi NonText            ctermfg=180 guifg=#E5C07B
  " hi SpecialKey         ctermfg=180 guifg=#E5C07B
  " Highlighting same symbols in the buffer at the current cursor position.
  hi CocHighlightText guibg=#3B4048
  hi Pmenu            guibg=#3E4452

  " gitgutter & signnify
  hi SignColumn           guibg=NONE
  hi SignifySignAdd       guifg=#618D3F
  hi SignifySignChange    guifg=#9E772E
  hi SignifySignDelete    guifg=#842E37
  hi link GitGutterAdd    SignifySignAdd
  hi link GitGutterChange SignifySignChange
  hi link GitGutterDelete SignifySignDelete

  " hi DashboardHeader ctermfg=114 guifg=#61AFEF
  hi DashboardHeader   ctermfg=59  guifg=#5c6370
  hi DashboardFooter   ctermfg=59  guifg=#5c6370
  hi DashboardShortcut ctermfg=145 guifg=#ABB2BF
  hi DashboardCenter   ctermfg=145 guifg=#ABB2BF
endfunction

" hi VertSplit          guifg=#4D5666 guibg=#363d49
" hi VertSplit          guifg=#181a1f guibg=NONE
