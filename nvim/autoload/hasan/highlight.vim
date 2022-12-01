function! hasan#highlight#load_custom_highlight(...) abort
  "/// Neovim Builin ///"
  hi TextInfo           guifg=#56B6C2 guibg=NONE
  hi TextSuccess        guifg=#61AFEF
  hi Cursor             guibg=#61AFEF gui=NONE
  " hi VertSplit          guibg=NONE guifg=#384051
  hi StatusLine         guibg=#2C323C guifg=#ABB2BF
  hi StatusLineNC       guibg=#2C323C guifg=#ABB2BF
  hi CursorColumn       guibg=#3B4048
  hi CursorLineFocus    guibg=#3E4452
  hi IncSearch          guibg=#e86671 gui=underline
  hi CurSearch          guibg=#e86671 guifg=#2C323C gui=underline
  hi SignColumn         guibg=NONE
  hi RedText            guifg=#ff0000
  hi WhiteText          guifg=#ffffff
  hi GrayText           guifg=#7386a5
  hi CursorLineDap      guibg=#173F1E guifg=none guisp=none cterm=underline
  hi! WhichKeyFloat     guibg=#2d3343
  hi! link Folded Comment

  "/// nvim-cmp ///"
  hi! Pmenu                         guibg=#202631 guifg=#a5b0c5
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

  "/// Treesitter highlights ///"
  hi OrgDone                    guifg=#7CBA4F
  hi TSRed                      guifg=#e86671
  hi! link @field               TSRed
  hi! link @property            TSRed
  hi! link @variable            TSRed
  hi! link htmlTag              @tag.delimiter
  hi! link @punctuation.special @keyword
  hi! @tag.delimiter            guifg=#ABB2BF gui=NONE
  hi! @variable.builtin         guifg=#E5C07B
  hi! @tag.attribute            guifg=#D19A66 gui=italic
  " custom highlights
  hi! @css.class                guifg=#D19A66
  hi! link @css.id              @method
  hi! link @css.pseudo_element  @attribute

  "/// LSP variable reference ///"
  hi LspReferenceText  guibg=#3B4048 gui=NONE
  hi LspReferenceWrite guibg=#463b48 gui=NONE
  hi LspReferenceRead  guibg=#3B4048 gui=NONE
  hi! link LspInfoBorder  FloatBorder

  "/// Plugins ///"
  hi! link HLNext IncSearch
  hi WhichKeySeparator guifg=#546178
  hi IndentBlanklineChar guifg=#323a48
  hi QuickScopePrimary   guifg=tomato gui=underline
  hi QuickScopeSecondary guifg=#d78787 gui=underline
  hi Sneak      gui=bold guibg=#ccff88 guifg=black
  hi! link SneakScope Cursor
  hi VM_Extend  guibg=#5C6370 guifg=#ABB2BF
  hi VM_Insert  guibg=#3E4452 guifg=#ABB2BF
  hi VM_Mono    guibg=#00af87 guifg=#ffffff
  " hi VM_Cursor
  hi AlphaTag          guifg=#424957
  hi AlphaHeader       guifg=#4d5666
  hi AlphaButtons      guifg=#546178
  "/// Floaterm ///"
  hi! link Floaterm NormalFloatFlat
  hi! link FloatermBorder FloatBorderFlat
  "/// symboal-outline.nvim ///"
  hi FocusedSymbol guibg=#4D5666 guifg=NONE
  "/// Lualine ///"
  hi LualineTabActive    guifg=#98C379 guibg=#3E4452
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
endfunction
