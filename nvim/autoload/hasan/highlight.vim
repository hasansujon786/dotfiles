function! hasan#highlight#load_custom_highlight(...) abort
  "/// Neovim Builin ///"
  hi TextInfo           guifg=#56B6C2 guibg=NONE
  hi TextSuccess        guifg=#61AFEF
  hi Cursor             guibg=#61AFEF gui=NONE
  hi ZenBorder          guifg=#1c212c
  hi VertSplit          guifg=#2b3043
  hi StatusLine         guibg=#2C323C guifg=#ABB2BF
  hi StatusLineNC       guibg=#2C323C guifg=#ABB2BF
  hi CursorLineFocus    guibg=#363C51
  hi IncSearch          guibg=#e86671 gui=underline
  hi CurSearch          guibg=#e86671 guifg=#2C323C gui=underline
  hi SignColumn         guibg=NONE
  hi RedText            guifg=#ff0000
  hi WhiteText          guifg=#ffffff
  hi GrayText           guifg=#7386a5
  hi CursorLineDap      guibg=#173F1E guifg=none guisp=none cterm=underline
  hi StatusLine         guibg=#2D3343
  hi! WhichKeyFloat     guibg=#2d3343
  hi! link Folded Comment
  hi! link Conceal String
  hi! link CursorColumn CursorLineFocus
  hi TelescopeMatching gui=NONE

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
  hi LspReferenceText  guibg=#3B4048 gui=NONE
  hi LspReferenceWrite guibg=#463b48 gui=NONE
  hi LspReferenceRead  guibg=#3B4048 gui=NONE
  hi! link LspInfoBorder  FloatBorder
  hi DiagnosticLineNrWarn  guifg=#ebc275 guibg=#4C4944
  hi DiagnosticLineNrError guifg=#ef5f6b guibg=#4D3542
  hi DiagnosticLineNrInfo  guifg=#4dbdcb guibg=#2C4855
  hi DiagnosticLineNrHint  guifg=#ca72e4 guibg=#45395A
  hi DiagnosticUnnecessary gui=underline

  "/// Plugins ///"
  hi! link LazyNormal NormalFloatFlat
  hi! link LazyButton CursorLineFocus
  hi! link MasonNormal NormalFloatFlat
  hi! link HlSearchNear IncSearch
  hi! link HlSearchLensNear WildMenu
  hi WhichKeySeparator guifg=#546178
  hi IndentBlanklineChar guifg=#323a48
  hi QuickScopePrimary   guifg=tomato gui=underline
  hi QuickScopeSecondary guifg=#d78787 gui=underline
  hi link SneakScope IncSearch
  hi Sneak      guibg=#ccff88 guifg=black gui=bold
  hi VM_Extend  guibg=#5C6370 guifg=#ABB2BF
  hi VM_Insert  guibg=#3E4452 guifg=#ABB2BF
  hi VM_Mono    guibg=#00af87 guifg=#ffffff
  " hi VM_Cursor
  "/// Alpha ///"
  hi AlphaTag        guifg=#424957
  hi AlphaHeader     guifg=#4d5666
  hi AlphaButtons    guifg=#546178 gui=NONE
  hi AlphaShourtCut  guifg=#546178 guibg=#28303e gui=NONE
  "/// Floaterm ///"
  hi! link Floaterm NormalFloatFlat
  hi! link FloatermBorder FloatBorderFlat
  "/// symboal-outline.nvim ///"
  hi! link FocusedSymbol DiagnosticLineNrWarn
  hi! CursorlineSymbol guibg=#4C4944
  "/// Lualine ///"
  hi LualineTabActive    guifg=#97CA72 guibg=#3E4452
  hi LualineTabInactive  guifg=#7386a5 guibg=#3E4452
  hi LualineTabSp        guifg=#2c3545 guibg=#3E4452
  "/// marks.nvim ///"
  hi! link MarkSignNumHL None
  hi! link MarkSignHL Comment
  "/// glance.nvim ///"
  hi GlancePreviewBorderBottom guifg=#111925 guibg=#1B222E
  hi GlanceListBorderBottom    guifg=#111925 guibg=#151C28
  hi! link GlancePreviewMatch  LspReferenceText
  hi! link GlanceListMatch     LspReferenceWrite
  hi! link GlanceIndent IndentBlanklineChar
  hi! link GlanceListCursorLine CursorLineFocus
  " hi! link GlancePreviewCursorLine CursorLineFocus

  "/// Telescope ///"
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
  hi! link NvimTreeIndentMarker IndentBlanklineChar
  hi! link NvimTreeWindowPicker TelescopeSelectionCaret
  hi! link NvimTreeWinSeparator VertSplit
  hi! NvimTreeNormal guibg=#1E242E guifg=#a5b0c5
  hi! NvimTreeWinBar guibg=#242B38 guifg=#75A899

  "/// Nebulous ///"
  hi NebulousInvisibe   guifg=#242B38
  hi NebulousDarker     guifg=#2a303c

  hi KisslineWinbarRenameBorder  guifg=#61afef guibg=#1E242E
endfunction
