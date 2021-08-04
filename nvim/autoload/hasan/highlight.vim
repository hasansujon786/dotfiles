if exists('g:bg_tranparent') && g:bg_tranparent == v:true
  " TODO: add better toggle system
  call nebulous#off()
endif

function hasan#highlight#load_custom_highlight() abort
  if exists('g:bg_tranparent') && g:bg_tranparent == v:true
    hi Normal guibg=NONE guifg=#ABB2BF
  endif
  hi TextInfo           guifg=#56B6C2
  hi TextSuccess        guifg=#61AFEF
  hi Cursor             guibg=#61AFEF gui=NONE
  hi VertSplit          guifg=#4D5666 guibg=#363d49
  hi CursorColumn       guibg=#3B4048
  hi CursorLineDefault  ctermbg=236 guibg=#2C323C
  hi CursorLineFocus    ctermbg=237 guibg=#3E4452
  hi! link Folded Comment

  hi WhichKeyFloat      guibg=#2C323C
  hi FeditBorder        guifg=#5c6370
  hi! link Fedit Normal
  hi! link TelescopeBorder FeditBorder
  " hi link NormalFloat Fedit
  " hi link FloatBorder FeditBorder

  " gitgutter & signnify
  hi SignColumn         guibg=NONE

  " hi DashboardHeader ctermfg=114 guifg=#61AFEF
  hi DashboardHeader   ctermfg=59  guifg=#5c6370
  hi DashboardFooter   ctermfg=59  guifg=#5c6370
  hi DashboardShortcut ctermfg=145 guifg=#ABB2BF
  hi DashboardCenter   ctermfg=145 guifg=#ABB2BF

  hi javascriptTSProperty guifg=#e86671
  hi javascriptTSVariable guifg=#e86671
  hi javascriptTSNamespace guifg=#e86671
  hi javascriptTSVariableBuiltin guifg=#E5C07B
  hi javascriptTSTagDelimiter guifg=#ABB2BF
  hi javascriptTSOperator guifg=#56B6C2
  hi jsxAttributeProperty guifg=#D19A66

  hi htmlTSTagDelimiter guifg=#ABB2BF
  hi htmlTSProperty guifg=#D19A66

  hi luaTSVariable guifg=#e86671
  hi luaTSField guifg=#e86671

  hi LspReferenceText guibg=#3B4048 gui=NONE
  hi LspReferenceWrite guibg=#3B4048 gui=NONE
  hi LspReferenceRead guibg=#3B4048 gui=NONE

  hi QuickScopePrimary   guifg=tomato gui=underline
  hi QuickScopeSecondary guifg=#d78787 gui=underline
endfunction

" call hasan#highlight#load_custom_highlight()
" hi VertSplit          guifg=#4D5666 guibg=#363d49
" hi VertSplit          guifg=#181a1f guibg=NONE
