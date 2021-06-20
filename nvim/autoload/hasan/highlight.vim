function hasan#highlight#load_custom_highlight() abort
  hi TextInfo           guifg=#56B6C2
  hi TextSuccess        guifg=#61AFEF
  hi Notification       guibg=#3E4452 guifg=#E5C07B
  hi Fedit              guibg=#282C34
  hi FeditBorder        guibg=#282C34 guifg=#5C6370

  hi VertSplit          guifg=#4D5666 guibg=#363d49
  hi CursorColumn       guibg=#3B4048
  hi CursorLineDefault  ctermbg=236 guibg=#2C323C
  hi CursorLineFocus    ctermbg=237 guibg=#3E4452
  hi! link TelescopeBorder Comment
  hi! link Folded Comment

  " gitgutter & signnify
  hi SignColumn         guibg=NONE
  hi GitGutterChange    guifg=#D19A66

  " hi DashboardHeader ctermfg=114 guifg=#61AFEF
  hi DashboardHeader   ctermfg=59  guifg=#5c6370
  hi DashboardFooter   ctermfg=59  guifg=#5c6370
  hi DashboardShortcut ctermfg=145 guifg=#ABB2BF
  hi DashboardCenter   ctermfg=145 guifg=#ABB2BF
endfunction

" call hasan#highlight#load_custom_highlight()
" hi VertSplit          guifg=#4D5666 guibg=#363d49
" hi VertSplit          guifg=#181a1f guibg=NONE
