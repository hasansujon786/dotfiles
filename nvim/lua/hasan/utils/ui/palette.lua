local util = require('hasan.utils.color')
-- cool local palette = require('onedark.palette')
local c = {
  bg0 = '#242b38',
  bg1 = '#2d3343',
  bg2 = '#343e4f',
  bg3 = '#363c51',
  bg_d = '#1e242e',
  black = '#151820',

  fg = '#a5b0c5',
  grey = '#546178',
  muted = '#68707E',
  layer = '#3E425D',
  light_grey = '#7d899f',

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
}

vim.g.onedark_theme_colors = {
  dark_vivid = { normal = { bg = c.bg0, fg = c.fg } },
}

local function set_custom_highlights()
  local normal_bg = c.bg0
  local fg = c.fg
  local cursorling_bg = c.bg1
  local float_bg = '#21252B' -- '#1c212c' c.bg_d
  local bg3 = c.bg3

  util.fg_bg('NormalFloat', fg, normal_bg)
  util.fg_bg('FloatBorder', c.cyan, normal_bg)
  util.fg_bg('NormalFloatFlat', fg, float_bg)
  util.fg_bg('FloatBorderFlat', float_bg, float_bg)
  util.fg_bg('FloatBorderHidden', bg3, normal_bg)

  util.fg_bg('CmpBorder', '#111925', float_bg)
  util.fg_bg('WhichKeyFloat', fg, cursorling_bg)
  util.fg_bg('WhichKeyBorder ', normal_bg, cursorling_bg)

  -- neo-tree
  local sp = '#1E242E'
  local btn = {
    normal = { fg = fg, bg = '#3E425D' },
    muted = { fg = '#8b95a7', bg = '#3E425D' },
    active = { fg = '#ffffff', bg = '#2D3343' },
  }

  if require('hasan.core.state').ui.neotree.source_selector_style == 'minimal' then
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
  -- /// LSP ///
    LspReferenceText      = { bg = '#3B4048', },
    LspReferenceWrite     = { bg = '#463b48', },
    LspReferenceRead      = { bg = '#3B4048', },
    DiagnosticLineNrWarn  = { fg = '#ebc275', bg = '#4C4944' },
    DiagnosticLineNrError = { fg = '#ef5f6b', bg = '#4D3542' },
    DiagnosticLineNrInfo  = { fg = '#4dbdcb', bg = '#2C4855' },
    DiagnosticLineNrHint  = { fg = '#ca72e4', bg = '#45395A' },
    DiagnosticUnnecessary = { underline = true },
    LspInfoBorder         = { link = 'FloatBorder' },

  -- /// glance.nvim ///
    GlanceWinBarTitle         = { fg = c.fg, bg = c.bg1 },
    GlanceWinBarFilename      = { fg = c.fg, bg = c.bg0 },
    GlanceWinBarFilepath      = { fg = c.grey, bg = c.bg0 },
    GlanceBorder              = { fg = c.bg3 },
    GlanceListNormal          = { fg = c.light_grey, bg = c.bg0 },
    GlancePreviewNormal       = { fg = c.fg, bg = c.bg_d },
    GlanceBorderTop           = { fg = c.bg3 },
    GlanceListFilename        = { fg = c.blue },
    GlanceFoldIcon            = { fg = c.blue },
    GlanceIndent              = { fg = c.bg1 },
    GlancePreviewMatch        = { link = 'LspReferenceText' },
    GlanceListMatch           = { link = 'LspReferenceWrite' },
    GlanceListCursorLine      = { link = 'CursorLineFocus' },
    GlanceListBorderBottom    = { link = 'GlanceBorder' },
    GlancePreviewBorderBottom = { link = 'GlanceBorder' },

  -- /// DiffView ///
    DiffviewDiffDelete        = { bg='#3c2729', fg='#1c212c' },
    DiffviewNormal            = { link = 'SidebarDark' },
    DiffviewEndOfBuffer       = { link = 'DiffviewNormal' },
    DiffviewCursorLine        = { link = 'CursorLineFocus' },
    DiffviewFolderSign        = { link = 'NeoTreeDirectoryIcon' },
    DiffviewFilePanelTitle    = { link = 'DiffviewFilePanelCounter' },
    DiffviewFilePanelRootPath = { link = 'NeoTreeRootName' },
    DiffviewStatusUntracked   = { link = 'DiffviewFilePanelDeletions' },
    DiffviewStatusModified    = { link = 'NeoTreeGitModified' },

  -- /// Neogit ///
    NeogitDiffContext          = { link = 'Normal' },
    NeogitCursorLine           = { link = 'CursorLine' },
    NeogitHunkHeader           = { fg = c.bg_d, bg = c.muted },
    NeogitHunkHeaderHighlight  = { fg = c.bg0, bg = '#c3a7e5' },
    NeogitDiffContextHighlight = { bg = '#323945' },

  -- /// Telescope ///
    TelescopePromptPrefix   = { fg = c.green },
    TelescopeSelectionCaret = { fg = c.orange, bg = cursorling_bg },
    TelescopePromptTitle    = { fg = c.orange },
    TelescopeMatching       = { fg = c.orange },
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
    NeoTreeCursorLine    = { link = 'CursorLineFocus' },
    NeoTreeNormal        = { link = 'SidebarDark' },
    NeoTreeNormalNC      = { link = 'SidebarDark' },
    NeoTreeVertSplit     = { link = 'EdgyWinSeparator' },
    NeoTreeWinSeparator  = { link = 'EdgyWinSeparator' },
    NeoTreeFloatNormal   = { link = 'TelescopeNormal' },
    -- hi! NeoTreeGitUntracked       gui=NONE

  -- /// nvim-cmp ///
    Pmenu                 = { link = 'NormalFloatFlat' },
    PmenuSel              = { bg = c.blue, fg = c.bg0 },
    PmenuSbar             = { bg = c.bg1 },
    PmenuThumb            = { bg = '#404959' },
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
    NuiNormalFloat = { link = 'NormalFloat' },
    NuiFloatBorder = { link = 'FloatBorderHidden' },
    NuiMenuItem    = { link = 'TelescopeSelectionCaret' },

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
    IblIndent = { fg = c.bg3 },
    IblScope  = { fg = c.grey },
  -- /// Folke collection ///
    FlashMatch = { fg = c.fg, bg = c.bg3 },
    FlashLabel = { fg = c.black, bg = c.green },
    NoiceMini    = { bg = '#000000' },
    LazyButton   = { bg = '#3E425D', fg = c.fg },
    LazyButtonActive = { link = 'WildMenu' },
    LazyNormal       = { link = 'NormalFloatFlat' },
  -- /// Mason ///
    MasonNormal             = { link = 'NormalFloatFlat' },
    MasonMutedBlock         = { link = 'LazyButton' },
    MasonHighlightBlockBold = { link = 'LazyButtonActive' },
  -- /// vim-visual-multi /// VM_Cursor
    VM_Extend = { bg = '#5C6370', fg = c.fg },
    VM_Mono   = { bg = '#00af87', fg = '#ffffff' },
    VM_Insert = { bg = c.bg3, fg = 'NONE' },
  -- Mix
    MarkSignHL          = { link = 'Comment' },
    QuickScopePrimary   = { fg = 'tomato', underline = true },
    QuickScopeSecondary = { fg = '#d78787', underline = true },
    TabBarInputBorder   = { fg = c.blue, bg = c.bg_d },
    WhichKeySeparator   = { fg = c.grey },
  }
  -- { underline = true, fg = btn.active.fg, bg = sp }
  for hlName, option in pairs(highlights) do
    vim.api.nvim_set_hl(0, hlName, option)
  end

  local links = {
    CursorLineFocus = 'Visual',
    CursorColumn = 'Visual',
    CurSearch = 'IncSearch',
    Folded = 'Comment',
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
