function hasan#highlight#load_custom_highlight() abort
  "/// Neovim Builin ///"
  hi TextInfo           guifg=#56B6C2 guibg=NONE
  hi TextSuccess        guifg=#61AFEF
  hi Cursor             guibg=#61AFEF gui=NONE
  hi VertSplit          guibg=#384051 guifg=#384051
  hi StatusLine         guibg=#384051 guifg=#ABB2BF
  hi StatusLineNC       guibg=#384051 guifg=#ABB2BF
  hi CursorColumn       guibg=#3B4048
  hi CursorLineFocus    guibg=#3E4452
  hi IncSearch          guibg=#e86671 gui=underline
  hi SignColumn         guibg=NONE
  hi FloatBorder        guibg=NONE guifg=#61AFEF
  hi! link NormalFloat Normal
  hi! link Folded Comment
  hi! link WhichKeyFloat Pmenu

  "/// Treesitter highlights ///"
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

  "/// LSP variable reference ///"
  hi LspReferenceText  guibg=#3B4048 gui=NONE
  hi LspReferenceWrite guibg=#3B4048 gui=NONE
  hi LspReferenceRead  guibg=#3B4048 gui=NONE
  hi DiagnosticHeader  guifg=#56b6c2 gui=bold

  "/// Plugins ///"
  hi IndentBlanklineChar guifg=#3B4048
  hi QuickScopePrimary   guifg=tomato gui=underline
  hi QuickScopeSecondary guifg=#d78787 gui=underline
  hi Sneak      gui=bold guibg=#E06B74 guifg=#282C33
  hi VM_Extend  guibg=#5C6370 guifg=#ABB2BF
  hi VM_Insert  guibg=#3E4452 guifg=#ABB2BF
  hi VM_Mono    guibg=#00af87 guifg=#ffffff
  " hi VM_Cursor
  " hi DashboardHeader ctermfg=114 guifg=#61AFEF
  hi DashboardHeader   guifg=#5c6370
  hi DashboardFooter   guifg=#5c6370
  hi DashboardShortcut guifg=#5c6370
  hi DashboardCenter   guifg=#5c6370
  hi! link HLNext IncSearch
  hi! link TelescopeBorder Comment
  hi! link TelescopePreviewBorder TelescopeBorder
  hi! link TelescopeResultsBorder TelescopeBorder
  hi! link TelescopePromptBorder  TelescopeBorder

  "/// nvim-cmp ///"
  hi CmpItemAbbrMatchFuzzy   guifg=#d99a5e gui=underline,bold
  hi CmpItemAbbrMatch        guifg=#d99a5e
  "
  hi! link CmpItemMenu Comment
  hi! CmpItemAbbrDeprecated guifg=#808080 gui=strikethrough
  "
  hi! CmpItemKindFunction   guifg=#ca72e4
  hi! CmpItemKindMethod     guifg=#ca72e4
  "
  hi! CmpItemKindVariable   guifg=#5ab0f6
  hi! link CmpItemKindField     CmpItemKindVariable
  hi! link CmpItemKindInterface CmpItemKindVariable
  "
  hi! CmpItemKindClass      guifg=#ebc275
  hi! link CmpItemKindEvent CmpItemKindClass
  hi! link CmpItemKindEnum  CmpItemKindClass
  hi! link CmpItemKindValue CmpItemKindClass
  "
  hi! CmpItemKindKeyword    guifg=#D4D4D4
  hi! CmpItemKindProperty   guifg=#D4D4D4
  hi! CmpItemKindUnit       guifg=#D4D4D4
  hi! CmpItemKindText       guifg=#9CDCFE

  "/// marks.nvim ///"
  hi! link MarkSignNumHL None
  hi! link MarkSignHL Comment

  "/// nui.nvim ///"
  hi NuiMenuItem   guifg=#d99a5e guibg=#2d3343
  hi NuiMenuNr     guifg=#d99a5e
endfunction

" call hasan#highlight#load_custom_highlight()
" hi VertSplit          guifg=#4D5666 guibg=#363d49
" hi VertSplit          guifg=#181a1f guibg=NONE
" hi Nebulous guibg=#363d49 -- ori
