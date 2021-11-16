function hasan#highlight#load_custom_highlight() abort
  " Nvim Interface
  hi TextInfo           guifg=#56B6C2 guibg=NONE
  hi TextSuccess        guifg=#61AFEF
  hi Cursor             guibg=#61AFEF gui=NONE
  hi VertSplit          guifg=#4D5666 guibg=#363d49
  hi CursorColumn       guibg=#3B4048
  hi CursorLineFocus    guibg=#3E4452
  hi Float              guibg=#242b38 guifg=#a5b0c5
  hi FloatBorder        guibg=#242b38 guifg=#5c6370
  hi IncSearch          guibg=#e86671 gui=underline
  hi SignColumn         guibg=NONE
  hi! link Folded Comment

  " Syntax highlights
  hi TSTagDelimiter    guifg=#ABB2BF
  hi TSProperty        guifg=#e86671
  hi TSVariable        guifg=#e86671
  hi TSNamespace       guifg=#e86671
  hi TSField           guifg=#e86671
  " hi TSParameter       guifg=#e86671 gui=italic
  hi TSTagAttribute    guifg=#D19A66 gui=italic
  hi TSConstructor     guifg=#E5C07B gui=NONE
  hi TSConstant        guifg=#E5C07B gui=NONE
  hi TSVariableBuiltin guifg=#E5C07B
  hi! link TSInclude TSKeyword

  " LSP variable reference
  hi LspReferenceText  guibg=#3B4048 gui=NONE
  hi LspReferenceWrite guibg=#3B4048 gui=NONE
  hi LspReferenceRead  guibg=#3B4048 gui=NONE

  " Plugins
  hi QuickScopePrimary   guifg=tomato gui=underline
  hi QuickScopeSecondary guifg=#d78787 gui=underline
  hi Sneak      gui=bold guibg=#E06B74 guifg=#282C33
  hi VM_Extend  guibg=#5C6370 guifg=#ABB2BF
  hi VM_Insert  guibg=#3E4452 guifg=#ABB2BF
  hi VM_Mono    guibg=#00af87 guifg=#ffffff
  " hi VM_Cursor
  " hi DashboardHeader ctermfg=114 guifg=#61AFEF
  hi DashboardHeader   ctermfg=59  guifg=#5c6370
  hi DashboardFooter   ctermfg=59  guifg=#5c6370
  hi DashboardShortcut ctermfg=145 guifg=#ABB2BF
  hi DashboardCenter   ctermfg=145 guifg=#ABB2BF
  hi! link HLNext IncSearch
  hi! link TelescopePreviewBorder FloatBorder
  hi! link TelescopeResultsBorder FloatBorder
  hi! link TelescopePromptBorder  FloatBorder
  hi! link CmpItemKind CmpItemMenu
  hi CmpItemAbbrMatchFuzzy   guifg=#E5C07B gui=underline
  hi CmpItemAbbrMatch        guifg=#E5C07B
endfunction

" call hasan#highlight#load_custom_highlight()
" hi VertSplit          guifg=#4D5666 guibg=#363d49
" hi VertSplit          guifg=#181a1f guibg=NONE
