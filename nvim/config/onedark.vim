" let g:onedark_terminal_italics = 1       " support italic fonts
try
  colorscheme onedark
catch
endtry

hi TextInfo           ctermfg=38  guifg=#56B6C2
hi TextSuccess        ctermfg=39  guifg=#61AFEF
hi Debug              ctermfg=180 guifg=#E5C07B
hi CursorLineDefault  ctermbg=236 guibg=#2C323C
hi CursorLineFocus    ctermbg=237 guibg=#3E4452
