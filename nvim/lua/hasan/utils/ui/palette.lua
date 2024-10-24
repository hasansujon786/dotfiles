local util = require('hasan.utils.color')
-- cool local palette = require('onedark.palette')
local c = {
  none = 'NONE',
  bg0 = '#242b38',
  bg1 = '#2d3343',
  bg2 = '#343e4f',
  bg3 = '#363c51',
  bg_d = '#1e242e',
  bg_d2 = '#1b222c',
  black = '#151820',

  fg = '#a5b0c5',
  light_grey = '#8b95a7',
  grey = '#546178',
  white = '#dfdfdf',
  muted = '#68707E',
  layer = '#3E425D',

  diff_add = '#303d27',
  diff_change = '#18344c',
  diff_delete = '#3c2729',
  diff_text = '#265478',

  aqua = '#6db9f7',
  yellow = '#ebc275',
  bg_yellow = '#f0d197',
  bg_blue = '#6db9f7',
  dark_yellow = '#9a6b16',

  red = '#ef5f6b',
  green = '#97ca72',
  orange = '#d99a5e',
  blue = '#5ab0f6',
  purple = '#ca72e4',
  cyan = '#4dbdcb',

  dark_purple = '#8f36a9',
  dark_red = '#a13131',
  dark_orange = '#9a6b16',
  dark_blue = '#127ace',
  dark_green = '#5e9437',
  dark_cyan = '#25747d',

  ligh_green = '#00a86d',
}

vim.g.onedark_theme_colors = {
  dark_vivid = { normal = { bg = c.bg0, fg = c.fg } },
}

local function set_custom_highlights()
  local normal_bg = c.bg0
  local fg = c.fg
  local cursorling_bg = c.bg1
  local float_bg = '#21252B' -- '#1c212c' c.bg_d
  local dark_border = '#111925'
  local context = '#2d324c'
  -- context = '#2c2f42'

  -- neo-tree
  local sp = '#1E242E'
  local btn = {
    normal = { fg = fg, bg = c.layer },
    muted = { fg = c.light_grey, bg = c.layer },
    active = { fg = c.white, bg = c.bg1 },
  }

  if require('core.state').ui.neotree.source_selector_style == 'minimal' then
    vim.api.nvim_set_hl(0, 'NeoTreeTabActive', { underline = true, fg = btn.active.fg, bg = sp })
    util.fg_bg('NeoTreeTabInactive', btn.muted.fg, sp)
    util.fg_bg('NeoTreeTabSeparatorActive', btn.active.fg, sp)
    util.fg_bg('NeoTreeTabSeparatorInactive', btn.muted.fg, sp)
  else
    util.fg_bg('NeoTreeTabActive', btn.active.fg, btn.active.bg)
    util.fg_bg('NeoTreeTabInactive', btn.muted.fg, btn.muted.bg)
    util.fg_bg('NeoTreeTabSeparatorActive', sp, btn.active.bg)
    util.fg_bg('NeoTreeTabSeparatorInactive', sp, btn.muted.bg)
  end

  -- stylua: ignore
  local highlights = {
    -- /// backgrounds ///
    NormalFloat             = { fg = fg, bg = normal_bg },
    FloatBorder             = { fg = c.cyan, bg = c.none },
    NormalFloatFlat         = { fg = fg, bg = float_bg },
    FloatBorderFlat         = { fg = dark_border, bg = float_bg },
    FloatBorderFlatHidden   = { fg = float_bg, bg = float_bg },
    SidebarDark             = { fg = c.fg, bg = c.bg_d },

    CursorLineFocus         = { bg = c.bg3 },
    LspInlayHint            = { fg = c.dark_cyan, bg = c.none },
    HeirlineTabActive       = { fg = c.green, bg = c.layer },
    HeirlineTabInactive     = { fg = c.red, bg = c.layer },
    WinSeparator            = { fg = c.bg_d2, bg = c.none },
    TabBarInputBorder       = { fg = c.blue, bg = c.bg_d },

    -- /// LSP ///
    LspReferenceText        = { bg = '#3B4048', },
    LspReferenceWrite       = { bg = '#463b48', },
    LspReferenceRead        = { bg = '#3B4048', },
    LspInfoBorder           = { link = 'FloatBorder' },
    DiagnosticLineNrWarn    = { fg = '#ebc275', bg = '#4C4944' },
    DiagnosticLineNrError   = { fg = '#ef5f6b', bg = '#4D3542' },
    DiagnosticLineNrInfo    = { fg = '#4dbdcb', bg = '#2C4855' },
    DiagnosticLineNrHint    = { fg = '#ca72e4', bg = '#45395A' },
    DiagnosticUnnecessary   = { link = 'DiagnosticUnderlineError' },
    DiagnosticUnderlineInfo = { link = 'DiagnosticUnderlineError' },
    DiagnosticUnderlineWarn = { link = 'DiagnosticUnderlineError' },
    DiagnosticUnderlineHint = { link = 'DiagnosticUnderlineError' },
    DiagnosticUnderlineError= { fg = 'none', underline = true, sp = c.red },
    NullLsInfoBorder        = { link = 'FloatBorder' },

    -- /// notify ///
    NotifyTitle               = { fg = c.light_grey, bg = c.none },
    NotifyTitleInfo           = { fg = c.green, bg = c.none },
    NotifyBorder              = { fg = c.grey, bg = c.none },
    NotifyBorderInfo          = { fg = c.green, bg = c.none  },

    -- /// edgy ///
    EdgyWinSeparator        = { fg = c.bg_d, bg = c.none },
    EdgyNormalDark          = { fg = c.fg, bg = c.bg_d },
    EdgyTitle               = { fg = c.light_grey, bg = '#202a3c' },
    EdgyIcon                = { fg = c.grey, bg = '#202a3c' },
    EdgyIconActive          = { fg = c.dark_cyan, bg = '#202a3c' },


    -- /// org ///
    CodeBlock                 = { bg = c.bg_d },
    ['@org.verbatim']         = { bg = '#75662e' },
    ['@org.block.org']        = { fg = c.diff_text },
    ['@markup.list.checked']  = { fg = c.ligh_green },
    ['@markup.link.url']      = { fg = '#8a5cf5', underline = true },
    ['@markup.list']          = { fg = '#8a5cf5' },

    -- /// glance.nvim ///
    GlancePreviewNormal       = { fg = c.fg, bg = c.bg_d },
    GlancePreviewLineNr       = { fg = '#495162', bg = c.bg_d },
    GlanceListNormal          = { fg = c.light_grey, bg = c.bg0 },
    GlanceWinBarFilename      = { fg = c.muted, bg = c.bg0, underline = true },
    GlanceWinBarFilepath      = { fg = c.muted, bg = c.bg0, underline = true },
    GlanceWinBarTitle         = { fg = c.muted, bg = c.bg0, underline = true }, -- reference count
    GlanceFoldIcon            = { fg = c.fg },
    GlanceListFilename        = { fg = c.white },
    GlanceIndent              = { fg = c.bg1 },
    GlanceListCursorLine      = { link = 'Visual' },
    GlancePreviewMatch        = { link = 'LspReferenceText' },
    GlanceListMatch           = { link = 'LspReferenceWrite' },
    GlanceBorderTop           = { fg = c.dark_blue  },
    GlanceBorderCursor        = { fg = c.dark_blue, underline = true },
    GlanceListBorderBottom    = { fg = c.dark_blue, bg = c.bg0 },
    GlancePreviewBorderBottom = { fg = c.dark_blue, bg = c.bg_d },

    -- /// DiffView ///
    DiffviewDiffDelete        = { bg = '#3c2729', fg = '#1c212c' },
    DiffviewNormal            = { link = 'SidebarDark' },
    DiffviewEndOfBuffer       = { link = 'DiffviewNormal' },
    DiffviewFolderSign        = { link = 'NeoTreeDirectoryIcon' },
    DiffviewFilePanelTitle    = { link = 'DiffviewFilePanelCounter' },
    DiffviewFilePanelRootPath = { link = 'NeoTreeRootName' },
    DiffviewStatusUntracked   = { link = 'DiffviewFilePanelDeletions' },
    DiffviewStatusModified    = { link = 'NeoTreeGitModified' },
    -- DiffviewCursorLine        = { link = 'CursorLineFocus' },

    -- /// Neogit ///
    NeogitDiffContext          = { link = 'Normal' },
    NeogitCursorLine           = { link = 'CursorLine' },
    NeogitHunkHeader           = { fg = c.bg_d, bg = c.muted },
    NeogitHunkHeaderHighlight  = { fg = c.bg0, bg = '#c3a7e5' },
    NeogitDiffContextHighlight = { bg = '#323945' },
    NeogitWinSeparator         = { fg = c.bg3 },

    -- /// Telescope ///
    TelescopePromptPrefix   = { fg = c.green },
    TelescopeSelectionCaret = { fg = c.orange, bg = cursorling_bg },
    TelescopePromptTitle    = { fg = c.orange, bg = dark_border },
    TelescopePreviewTitle   = { fg = c.bg3, bg = dark_border },
    TelescopeResultsTitle   = { fg = c.bg3, bg = dark_border },
    TelescopeMatching       = { fg = c.orange },
    TelescopeMultiSelection = { fg = c.purple },
    TelescopeTitle          = { link = 'Comment' },
    TelescopeBorder         = { link = 'FloatBorderFlat' },
    TelescopeNormal         = { link = 'NormalFloatFlat' },
    TelescopeSelection      = { link = 'Cursorline' },

    -- /// neo-tree.nvim ///
    NeoTreeDirectoryIcon = { fg = '#8094B4' },
    NeoTreeFloatBorder   = { bg = float_bg, fg = c.cyan },
    NeoTreeFloatTitle    = { bg = c.cyan, fg = float_bg},
    NeoTreeModified      = { link = 'String' },
    NeoTreeMessage       = { link = 'Comment' },
    NeoTreeDimText       = { link = 'Comment' },
    NeoTreeIndentMarker  = { link = 'IblIndent' },
    NeoTreeNormal        = { link = 'SidebarDark' },
    NeoTreeNormalNC      = { link = 'SidebarDark' },
    NeoTreeVertSplit     = { link = 'EdgyWinSeparator' },
    NeoTreeWinSeparator  = { link = 'EdgyWinSeparator' },
    NeoTreeFloatNormal   = { link = 'TelescopeNormal' },
    -- NeoTreeCursorLine    = { link = 'CursorLineFocus' },
    -- hi! NeoTreeGitUntracked       gui=NONE

    -- /// nvim-cmp ///
    Pmenu                 = { link = 'NormalFloatFlat' },
    PmenuSel              = { bg = c.blue, fg = c.bg0 },
    PmenuSbar             = { bg = c.bg1 },
    PmenuThumb            = { bg = '#404959' },
    CmpBorder             = { fg = dark_border, bg = float_bg },
    CmpItemMenu           = { fg = c.grey },
    CmpItemAbbrMatchFuzzy = { fg = '#d99a5e', underline = true },
    CmpItemAbbrMatch      = { fg = '#d99a5e' },
    CmpItemAbbrDeprecated = { fg = '#808080', strikethrough = true },
    CmpItemKindFunction   = { fg = '#ca72e4' },
    CmpItemKindMethod     = { link = 'CmpItemKindFunction' },
    CmpItemKindModule     = { link = 'CmpItemKindFunction' },
    CmpItemKindKeyword    = { link = 'CmpItemKindFunction' },
    CmpItemKindVariable   = { fg = '#5ab0f6' },
    CmpItemKindFile       = { link = 'CmpItemKindVariable' },
    CmpItemKindField      = { link = 'CmpItemKindVariable' },
    CmpItemKindInterface  = { link = 'CmpItemKindVariable' },
    CmpItemKindClass      = { fg = '#ebc275' },
    CmpItemKindEvent      = { link = 'CmpItemKindClass' },
    CmpItemKindStruct     = { link = 'CmpItemKindClass' },
    CmpItemKindEnum       = { link = 'CmpItemKindClass' },
    CmpItemKindValue      = { link = 'CmpItemKindClass' },
    CmpItemKindEnumMember = { link = 'CmpItemKindClass' },
    CmpItemKindConstructor= { link = 'CmpItemKindClass' },
    CmpItemKindProperty   = { fg = '#D4D4D4' },
    CmpItemKindConstant   = { link = 'CmpItemKindProperty' },
    CmpItemKindTypeParamet= { link = 'CmpItemKindProperty' },
    CmpItemKindUnit       = { link = 'CmpItemKindProperty' },
    CmpItemKindText       = { fg = '#9CDCFE' },
    CmpItemKindSnippet    = { fg = '#9CDCFE' },

    -- /// Nebulous ///
    Nebulous         = { fg = '#323c4e' },
    NebulousItalic   = { fg = '#323c4e', italic = true },
    NebulousDarker   = { fg = '#2a303c' },
    NebulousInvisibe = { fg = c.bg0 },
    EndOfBuffer      = { bg = 'NONE' },

    -- /// nui.nvim ///
    NuiNormalFloat = { link = 'Normal' },
    NuiFloatBorder = { link = 'FloatBorder' },
    NuiBorderTitle = { link = 'String' },
    NuiMenuItem    = { fg = c.black, bg = c.cyan },

    NuiComponentsCheckboxLabel             = { fg = c.light_grey },
    NuiComponentsCheckboxIcon              = { fg = c.light_grey },
    NuiComponentsCheckboxLabelChecked      = { fg = c.yellow },
    NuiComponentsCheckboxIconChecked       = { fg =  c.yellow },

    NuiComponentsTreeNodeFocused           = { link = 'Visual' },
    NuiComponentsInfo                      = { fg = c.grey, bg = c.bg_d2 },
    NuiComponentsTreeSpectreIcon           = { fg = c.grey },
    NuiComponentsTreeSpectreSearchValue    = { link = 'Search' },
    NuiComponentsTreeSpectreSearchOldValue = { link = 'Search' },
    NuiComponentsTreeSpectreSearchNewValue = { link = 'IncSearch' },
    NuiComponentsTreeSpectreReplaceSuccess = { link = 'String' },
    NuiComponentsTreeSpectreCodeLine       = { fg = c.none },
    NuiComponentsTreeSpectreFileName       = { fg = c.purple },

    -- /// Alpha ///
    AlphaTag       = { fg = '#4d5666' },
    AlphaHeader    = { fg = '#4d5666' },
    AlphaButtons   = { fg = c.grey },
    AlphaShourtCut = {  fg = '#7386a5', bg = c.bg1 },
    -- /// Floaterm ///
    FloatermBorder = { link = 'Comment' },
    -- /// outline.nvim ///
    OutlineGuides = { link = 'IblIndent' },
    OutlineCurrent = { fg = c.yellow, underline = true },
    -- /// indent-blankline.nvim ///
    IblIndent             = { fg = c.bg3 },
    IblScope              = { fg = c.grey },
    MiniIndentscopeSymbol = { link = 'IblScope' },
    -- /// Folke collection ///
    FlashMatch                  = { fg = c.fg, bg = c.bg3 },
    FlashLabel                  = { fg = c.black, bg = c.green },
    FlashCurrent                = { fg = c.bg0, bg = '#e86671' },
    NoiceMini                   = { bg = '#000000' },
    NoiceFormatConfirmDefault   = { link = 'LazyButton' },
    LazyNormal                  = { link = 'NormalFloatFlat' },
    LazyButton                  = { bg = c.layer, fg = c.fg },
    LazyButtonActive            = { link = 'WildMenu' },
    WhichKeySeparator           = { fg = c.grey },
    WhichKeyBorder              = { fg = normal_bg, bg = cursorling_bg },
    WhichKeyNormal              = { fg = fg, bg = cursorling_bg },
    WhichKeyFloat               = { fg = fg, bg = cursorling_bg },
    WhichKeyTitle               = { fg = c.muted, bg = normal_bg },
    TreesitterContext           = { bg = context },
    TreesitterContextSeparator  = { bg = c.none, fg = c.grey },
    TreesitterContextLineNumber = { bg = context, fg = c.grey },
    -- /// Mason ///
    MasonNormal                 = { link = 'NormalFloatFlat' },
    MasonMutedBlock             = { link = 'LazyButton' },
    MasonHighlightBlockBold     = { link = 'LazyButtonActive' },
    -- /// vim-visual-multi /// VM_Cursor
    VM_Extend = { bg = c.dark_red, fg = c.white },
    VM_Cursor = { bg = '#8a8a8a', fg = '#204364' },
    VM_Insert = { bg = '#4c4e50', fg = 'NONE' },
    VM_Mono   = { bg = c.ligh_green, fg = '#ffffff' },
    -- Mix
    MarkSignHL          = { link = 'Comment' },
    EyelinerPrimary     = { fg = 'tomato', underline = true },
    EyelinerSecondary   = { fg = '#d78787', underline = true },
  }
  -- { underline = true, fg = btn.active.fg, bg = sp }
  for hlName, option in pairs(highlights) do
    vim.api.nvim_set_hl(0, hlName, option)
  end

  local links = {
    CursorColumn = 'CursorLineFocus',
    CurSearch = 'IncSearch',
    Conceal = 'String',

    -- https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/theme.lua#L255-L272
    -- ['@lsp.type.comment'] = '@comment',
    -- ['@lsp.type.namespace'] = '@namespace',
    -- ['@lsp.type.type'] = '@type',
    -- ['@lsp.type.class'] = '@type',
    -- ['@lsp.type.enum'] = '@type',
    -- ['@lsp.type.interface'] = '@type',
    -- ['@lsp.type.struct'] = '@structure',
    -- ['@lsp.type.parameter'] = '@parameter',
    ['@lsp.type.variable'] = '@variable',
    ['@lsp.type.property'] = '@property',
    ['@lsp.type.member'] = '@method',
    -- ['@lsp.type.enumMember'] = '@constant',
    -- ['@lsp.type.function'] = '@function',
    -- ['@lsp.type.method'] = '@method',
    -- ['@lsp.type.macro'] = '@macro',
    -- ['@lsp.type.decorator'] = '@function',
    -- ['@lsp.type.keyword'] = '@keyword',

    ['@lsp.mod.readonly'] = '@Constant',
    -- ['@lsp.typemod.variable.readonly'] = '@constant',
    ['@lsp.typemod.method.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.function.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.operator.injected'] = '@operator',
    ['@lsp.typemod.string.injected'] = '@string',
    ['@lsp.typemod.variable.defaultLibrary'] = '@variable.builtin',
    ['@lsp.typemod.variable.injected'] = '@variable',
    ['@lsp.typemod.function.declaration'] = '@function',
    ['@lsp.typemod.function.readonly'] = '@function',
  }
  for newgroup, oldgroup in pairs(links) do
    vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = false })
  end
end

return {
  set_custom_highlights = set_custom_highlights,
}
