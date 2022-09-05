function hasan#highlight#load_custom_highlight(...) abort
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
  hi SignColumn         guibg=NONE
  " guibg=#1e242f
  hi PmenuSel           guibg=#495369 guifg=NONE
  hi RedText            guifg=#ff0000
  hi WhiteText          guifg=#ffffff
  hi GrayText           guifg=#7386a5
  hi CursorLineDap      guibg=#173F1E guifg=none guisp=none cterm=underline
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
  hi OrgDone           guifg=#7CBA4F

  "/// LSP variable reference ///"
  hi LspReferenceText  guibg=#3B4048 gui=NONE
  hi LspReferenceWrite guibg=#463b48 gui=NONE
  hi LspReferenceRead  guibg=#3B4048 gui=NONE

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
  " hi DashboardHeader ctermfg=114 guifg=#61AFEF
  hi DashboardHeader   guifg=#5c6370
  hi DashboardFooter   guifg=#5c6370
  hi DashboardShortcut guifg=#5c6370
  hi DashboardCenter   guifg=#5c6370
  "/// Floaterm ///"
  hi! link Floaterm NormalFloatFlat
  hi! link FloatermBorder FloatBorderFlat
  "/// symboal-outline.nvim ///"
  hi FocusedSymbol guibg=#4D5666 guifg=NONE

  "/// nvim-cmp ///"
  " CmpItemAbbr
  hi! CmpItemAbbrMatchFuzzy         guifg=#d99a5e gui=underline,bold
  hi! CmpItemAbbrMatch              guifg=#d99a5e
  hi! link CmpItemMenu              Comment
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

  "/// marks.nvim ///"
  hi! link MarkSignNumHL None
  hi! link MarkSignHL Comment

  "/// Telescope ///"
  hi! link TelescopeTitle Comment
  hi! link TelescopeBorder FloatBorderFlat
  hi! link TelescopeNormal NormalFloatFlat
  hi! link TelescopePreviewBorder TelescopeBorder
  hi! link TelescopeResultsBorder TelescopeBorder
  hi! link TelescopePromptBorder  TelescopeBorder

  "/// nui.nvim ///"
  hi NuiMenuNr     guifg=#d99a5e
  hi! link NuiNormalFloat NormalFloat
  hi! link NuiFloatBorder FloatBorderHidden
  hi! link NuiMenuItem    TelescopeSelectionCaret

  "/// nvim-tree.nvim ///"
  hi! link NvimTreeCursorLine CursorLineFocus
  hi! link NvimTreeIndentMarker IndentBlanklineChar
  hi! link NvimTreeWindowPicker TelescopeSelectionCaret
endfunction

" call hasan#highlight#load_custom_highlight()
" hi VertSplit          guifg=#4D5666 guibg=#363d49
" hi VertSplit          guifg=#181a1f guibg=NONE
" hi Nebulous guibg=#363d49 -- ori
