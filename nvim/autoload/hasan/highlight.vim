function! hasan#highlight#load_custom_highlight(...) abort
  "/// Neovim Builin ///"
  hi TextInfo           guifg=#56B6C2 guibg=NONE
  hi TextSuccess        guifg=#61AFEF
  hi Cursor             guibg=#61AFEF gui=NONE
  hi ZenBorder          guifg=#1c212c
  hi VertSplit          guifg=#2b3043
  hi StatusLine         guibg=#2D3343 guifg=#ABB2BF
  hi StatusLineNC       guibg=#2D3343 guifg=#ABB2BF
  hi CursorLineFocus    guibg=#363C51
  hi SignColumn         guibg=NONE
  hi RedText            guifg=#ff0000
  hi WhiteText          guifg=#ffffff
  hi GrayText           guifg=#7386a5
  hi CursorLineDap      guibg=#173F1E guifg=none guisp=none cterm=underline
  hi SidebarDark        guifg=#a5b0c5 guibg=#1e242e
  hi IncSearch          guibg=#e86671 guifg=#2C323C gui=underline
  hi! link CurSearch IncSearch
  hi! link Folded Comment
  hi! link Conceal String
  hi! link CursorColumn CursorLineFocus

  "/// nvim-cmp ///"
  hi! link Pmenu NormalFloatFlat
  hi! PmenuThumb                    guibg=#404959
  " CmpItemAbbr
  hi! CmpItemMenu                   guifg=#4D5666
  hi! CmpItemAbbrMatchFuzzy         guifg=#d99a5e gui=underline,bold
  hi! CmpItemAbbrMatch              guifg=#d99a5e
  hi! CmpItemAbbrDeprecated         guifg=#808080 gui=strikethrough
  hi! CmpItemKindFunction           guifg=#ca72e4
  hi! link CmpItemKindMethod        CmpItemKindFunction
  hi! link CmpItemKindModule        CmpItemKindFunction
  hi! link CmpItemKindKeyword       CmpItemKindFunction
  hi! CmpItemKindVariable           guifg=#5ab0f6
  hi! link CmpItemKindFile          CmpItemKindVariable
  hi! link CmpItemKindField         CmpItemKindVariable
  hi! link CmpItemKindInterface     CmpItemKindVariable
  hi! CmpItemKindClass              guifg=#ebc275
  hi! link CmpItemKindEvent         CmpItemKindClass
  hi! link CmpItemKindStruct        CmpItemKindClass
  hi! link CmpItemKindEnum          CmpItemKindClass
  hi! link CmpItemKindValue         CmpItemKindClass
  hi! link CmpItemKindEnumMember    CmpItemKindClass
  hi! link CmpItemKindConstructor   CmpItemKindClass
  hi! CmpItemKindProperty           guifg=#D4D4D4
  hi! link CmpItemKindConstant      CmpItemKindProperty
  hi! link CmpItemKindTypeParameter CmpItemKindProperty
  hi! link CmpItemKindUnit          CmpItemKindProperty
  hi! CmpItemKindText               guifg=#9CDCFE
  hi! CmpItemKindSnippet            guifg=#9CDCFE

  "/// LSP variable reference ///"
  hi! link LspInfoBorder     FloatBorder
  hi! link NullLsInfoBorder  FloatBorder
  hi LspReferenceText      guibg=#3B4048 gui=NONE
  hi LspReferenceWrite     guibg=#463b48 gui=NONE
  hi LspReferenceRead      guibg=#3B4048 gui=NONE
  hi DiagnosticLineNrWarn  guifg=#ebc275 guibg=#4C4944
  hi DiagnosticLineNrError guifg=#ef5f6b guibg=#4D3542
  hi DiagnosticLineNrInfo  guifg=#4dbdcb guibg=#2C4855
  hi DiagnosticLineNrHint  guifg=#ca72e4 guibg=#45395A
  hi DiagnosticUnnecessary gui=underline
  hi DiagnosticUnderlineError gui=underline guifg=#E61B1B

  "/// Plugins ///"
  hi! NoiceMini guibg=#000000
  hi! LazyButton      guibg=#3E425D guifg=#ABB2BF
  hi! link LazyNormal NormalFloatFlat
  hi! link MasonNormal NormalFloatFlat
  hi! link HlSearchNear IncSearch
  hi! link HlSearchLensNear WildMenu
  hi WhichKeySeparator guifg=#546178
  hi QuickScopePrimary   guifg=tomato gui=underline
  hi QuickScopeSecondary guifg=#d78787 gui=underline
  hi link SneakScope IncSearch
  hi Sneak      guibg=#ccff88 guifg=black gui=bold
  hi VM_Extend  guibg=#5C6370 guifg=#ABB2BF
  hi VM_Insert  guibg=#3E4452 guifg=#ABB2BF
  hi VM_Mono    guibg=#00af87 guifg=#ffffff
  " hi VM_Cursor
  "/// Alpha ///"
  hi AlphaTag        guifg=#546178
  hi AlphaHeader     guifg=#4d5666
  hi AlphaButtons    guifg=#546178 gui=NONE
  hi AlphaShourtCut  guifg=#7386a5 guibg=#28303e gui=NONE
  "/// Floaterm ///"
  hi! link Floaterm NormalFloatFlat
  hi! link FloatermNC NormalFloatFlat
  hi! link FloatermBorder FloatBorderFlat
  "/// symboal-outline.nvim ///"
  hi! link FocusedSymbol DiagnosticLineNrHint
  "/// indent-blankline.nvim ///"
  hi IndentBlanklineChar guifg=#323a48
  hi IblIndent guifg=#323a48
  hi IblScope  guifg=#546178

  "/// Lualine ///"
  hi LualineTabActive    guifg=#97CA72 guibg=#3E4452
  hi LualineTabInactive  guifg=#7386a5 guibg=#3E4452
  hi LualineTabSp        guifg=#2c3545 guibg=#3E4452
  hi WinbarTabGreen      guifg=#97CA72 guibg=#242B38
  hi WinbarTabMuted      guifg=#3d4451 guibg=#242B38
  hi WinbarTabItem       guifg=#5C6370 guibg=#242B38
  "/// marks.nvim ///"
  hi! link MarkSignNumHL None
  hi! link MarkSignHL Comment
  "/// Telescope ///"
  hi TelescopeMatching gui=NONE
  hi! link TelescopeTitle Comment
  hi! link TelescopeBorder FloatBorderFlat
  hi! link TelescopeNormal NormalFloatFlat
  hi! link TelescopePreviewBorder TelescopeBorder
  hi! link TelescopeResultsBorder TelescopeBorder
  hi! link TelescopePromptBorder  TelescopeBorder

  "/// nui.nvim ///"
  hi! link NuiNormalFloat NormalFloat
  hi! link NuiFloatBorder FloatBorderHidden
  hi! link NuiMenuItem    TelescopeSelectionCaret

  "/// nvim-tree.nvim ///"
  hi! link NvimTreeCursorLine   CursorLineFocus
  hi! link NvimTreeIndentMarker IblIndent
  hi! link NvimTreeWindowPicker TelescopeSelectionCaret
  hi! link NvimTreeWinSeparator VertSplit
  hi! NvimTreeNormal guibg=#1E242E guifg=#a5b0c5
  hi! NvimTreeWinBar guibg=#242B38 guifg=#75A899

  "/// neo-tree.nvim ///"
  hi! link NeoTreeModified       String
  hi! link NeoTreeMessage        Comment
  hi! link NeoTreeDimText        Comment
  hi! link NeoTreeIndentMarker   IblIndent
  hi! link NeoTreeCursorLine     CursorLineFocus
  hi! link NeoTreeNormal         SidebarDark
  hi! link NeoTreeNormalNC       SidebarDark
  hi! link NeoTreeVertSplit      WinSeparator
  hi! NeoTreeGitUntracked        gui=NONE
  hi! NeoTreeDirectoryIcon       guifg=#8094B4
  hi! link NeoTreeFloatNormal    TelescopeNormal
  hi! NeoTreeFloatBorder         guibg=#1C212C guifg=#4dbdcb
  hi! NeoTreeFloatTitle          guibg=#4dbdcb guifg=#1C212C
  " hi! NeoTreeRootName            guifg=#ABB2BF gui=bold
  " hi! NeoTreeWinSeparator        guifg=#2b3043 guibg=#1e242e

  "/// Nebulous ///"
  hi Nebulous           guifg=#323c4e
  hi NebulousItalic     guifg=#323c4e gui=italic
  hi NebulousDarker     guifg=#2a303c
  hi NebulousInvisibe   guifg=#242B38
  hi EndOfBuffer        guibg=NONE

  hi KisslineWinbarRenameBorder  guifg=#61afef guibg=#1E242E

  "/// Neogit ///"
  hi! link NeogitDiffContext Normal
  hi! link NeogitCursorLine CursorLine
  hi NeogitDiffContextHighlight guibg=#323945
  hi NeogitHunkHeader           guifg=#242b38 guibg=#7c8088 gui=bold
  hi NeogitHunkHeaderHighlight  guifg=#242b38 guibg=#c3a7e5 gui=bold

  "/// glance.nvim ///"
  hi GlanceBorder                    guifg=#1C212C guibg=NONE
  hi! GlanceBorderTop                guifg=#1E242E guibg=NONE
  hi GlanceWinBarFilename            guifg=#ffffff guibg=#2D3343
  hi GlanceWinBarFilepath            guifg=#546178 guibg=#2D3343
  hi GlanceWinBarTitle               guifg=#a5b0c6 guibg=#2D3343
  hi GlancePreviewNormal             guifg=#a5b0c6 guibg=#1E242E
  hi GlanceListFilename              guifg=#5ab0f6 guibg=NONE
  hi GlanceFoldIcon                  guifg=#a5b0c6 guifg=#a5b0c6
  hi GlanceListNormal                guifg=#8b95a7 guibg=#242B38
  hi! link GlancePreviewMatch        LspReferenceText
  hi! link GlanceListMatch           LspReferenceWrite
  hi! link GlanceIndent              IblIndent
  hi! link GlanceListCursorLine      CursorLineFocus
  hi! link GlanceListBorderBottom    GlanceBorder
  hi! link GlancePreviewBorderBottom GlanceBorder
endfunction
