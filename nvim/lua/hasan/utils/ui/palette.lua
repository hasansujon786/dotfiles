local c = {
  none = 'NONE',
  bg0 = '#242b38',
  bg1 = '#2d3343',
  bg2 = '#343e4f',
  bg3 = '#363c51',
  bg_d = '#1e242e',
  bg_d2 = '#1b222c',
  black = '#151820',

  fg = '#abb2bf',
  light_grey = '#8b95a7',
  grey = '#546178',
  white = '#dfdfdf',
  muted = '#68707E',
  layer = '#3E425D',

  red = '#ef5f6b',
  green = '#97ca72',
  orange = '#d99a5e',
  yellow = '#ebc275',
  blue = '#5ab0f6',
  purple = '#ca72e4',
  cyan = '#4dbdcb',

  diff_add = '#303d27',
  diff_change = '#18344c',
  diff_delete = '#3c2729',
  diff_text = '#265478',

  bg_yellow = '#f0d197',
  bg_blue = '#6db9f7',

  dim_red = '#4D3542',
  dim_green = '#3B4048',
  dim_yellow = '#4C4944',
  dim_blue = '#204364',
  dim_purple = '#45395A',
  dim_cyan = '#2C4855',

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

local use_dim_bg = require('core.state').lsp.diagnosgic.sign.use_dim_bg

local function set_custom_highlights()
  local hl = vim.api.nvim_set_hl
  local normal_bg = c.bg0
  local cursorling_bg = c.bg1
  local float_bg = '#21252B' -- '#1c212c' c.bg_d
  local dark_border = '#111925'
  local context = '#2d324c' -- #2c2f42

  -- neo-tree
  local neo_tree = {
    sp_bg = c.bg_d,
    normal = { fg = c.fg, bg = c.layer },
    active = { fg = c.white, bg = c.bg1 },
    inactive = { fg = c.light_grey, bg = c.layer },
  }

  if require('core.state').ui.neotree.source_selector_style == 'minimal' then
    hl(0, 'NeoTreeTabActive', { underline = true, fg = neo_tree.active.fg, bg = neo_tree.sp_bg })
    hl(0, 'NeoTreeTabInactive', { fg = neo_tree.inactive.fg, bg = neo_tree.sp_bg })
    hl(0, 'NeoTreeTabSeparatorActive', { fg = neo_tree.active.fg, bg = neo_tree.sp_bg })
    hl(0, 'NeoTreeTabSeparatorInactive', { fg = neo_tree.inactive.fg, bg = neo_tree.sp_bg })
  else
    hl(0, 'NeoTreeTabActive', { fg = neo_tree.active.fg, bg = neo_tree.active.bg })
    hl(0, 'NeoTreeTabInactive', { fg = neo_tree.inactive.fg, bg = neo_tree.inactive.bg })
    hl(0, 'NeoTreeTabSeparatorActive', { fg = neo_tree.sp_bg, bg = neo_tree.active.bg })
    hl(0, 'NeoTreeTabSeparatorInactive', { fg = neo_tree.sp_bg, bg = neo_tree.inactive.bg })
  end

  -- stylua: ignore
  local highlights = {
    -- /// backgrounds ///
    FloatBorderTitle        = { bg = c.cyan, fg = float_bg },
    NormalFloatFlat         = { fg = c.fg, bg = float_bg },
    FloatBorderFlat         = { fg = dark_border, bg = float_bg },
    FloatBorderFlatHidden   = { fg = float_bg, bg = float_bg },
    SidebarDark             = { fg = c.fg, bg = c.bg_d },
    Folded                  = { fg = c.fg, bg = 'none' },
    Visual                  = { bg = c.dim_blue },
    FloatBorder             = { fg = c.cyan, bg = c.none },
    NonText                 = { fg = c.layer, bg = c.none },
    LineNr                  = { fg = '#495162', bg = c.none },

    DirectoryIcon           = { fg = '#8094B4' },
    CursorLineFocus         = { bg = c.bg3 },
    LspInlayHint            = { fg = c.dark_cyan, bg = c.none },
    HeirlineTabActive       = { fg = c.green, bg = c.layer },
    HeirlineTabInactive     = { fg = c.red, bg = c.layer },
    WinSeparator            = { fg = c.bg_d2, bg = c.none },
    TabBarInputBorder       = { fg = c.blue, bg = c.bg_d },
    MatchParen              = { link = 'DiagnosticLineNrInfo' },
    CursorColumn            = { link = 'CursorLineFocus' },
    CurSearch               = { link =  'IncSearch' },
    Conceal                 = { link =  'String' },
    ['@keyword.function']   = { fg = c.purple, italic = true },
    WezTab                  = { fg = c.orange, bg = context },
    WezTabBorder            = { fg = dark_border, bg = c.none },

    PmenuSel                = { bg = c.bg3 },
    PmenuSbar               = { bg = c.bg1 },
    PmenuThumb              = { bg = '#404959' },
    Pmenu                   = { link = 'NormalFloatFlat' },

    SuperKanbanCardNormal        = { bg = float_bg },
    SuperKanbanListWinbar        = { fg = c.yellow, bg = '#343f51' },
    SuperKanbanListWinbarEdge    = { fg = c.bg0, bg = c.none },
    SuperKanbanBubble            = { fg = c.bg0, bg = c.cyan },
    SuperKanbanBubbleEdge        = { fg = c.cyan },
    SuperKanbanBoardFileName     = { fg = c.bg0, bg = c.orange },
    SuperKanbanBoardFileNameEdge = { fg = c.orange },
    SuperKanbanTag               = { fg = c.orange, bg = '#4C4944' },

    -- /// LSP ///
    LspReferenceText        = { bg = c.dim_green },
    LspReferenceRead        = { bg = c.dim_green },
    LspReferenceWrite       = { bg = c.dim_red },
    LspInfoBorder           = { link = 'FloatBorder' },
    DiagnosticLineNrWarn    = { fg = c.yellow, bg = use_dim_bg and c.dim_yellow or c.none },
    DiagnosticLineNrError   = { fg = c.red, bg = use_dim_bg and c.dim_red or c.none },
    DiagnosticLineNrInfo    = { fg = c.cyan, bg = use_dim_bg and c.dim_cyan or c.none },
    DiagnosticLineNrHint    = { fg = c.purple, bg = use_dim_bg and c.dim_purple or c.none },
    DiagnosticUnnecessary   = { link = 'DiagnosticUnderlineError' },
    DiagnosticUnderlineInfo = { link = 'DiagnosticUnderlineError' },
    DiagnosticUnderlineWarn = { link = 'DiagnosticUnderlineError' },
    DiagnosticUnderlineHint = { link = 'DiagnosticUnderlineError' },
    DiagnosticUnderlineError= { fg = 'none', underline = true, sp = c.red },

    -- /// notify ///
    NotifyTitle             = { fg = c.light_grey, bg = c.none },
    NotifyTitleInfo         = { fg = c.green, bg = c.none },
    NotifyBorder            = { fg = c.grey, bg = c.none },
    NotifyBorderInfo        = { fg = c.green, bg = c.none  },

    -- /// edgy ///
    EdgyWinSeparator        = { fg = c.bg_d, bg = c.none },
    EdgyNormalDark          = { fg = c.fg, bg = c.bg_d },
    EdgyTitle               = { fg = c.light_grey, bg = c.bg0 },
    EdgyIcon                = { fg = c.grey, bg = c.bg0 },
    EdgyIconActive          = { fg = c.dark_cyan, bg = c.bg0 },

    -- /// snacks ///
    SnacksNormal            = { fg = c.fg, bg = float_bg },
    SnacksDashboardHeader   = { fg = c.blue },
    SnacksDashboardDesc     = { fg = c.light_grey, italic = true },
    SnacksDashboardKey      = { bg = c.bg3, fg = c.light_grey, italic = false },
    SnacksDashboardKeyAlt   = { fg = c.bg3 },
    SnacksDashboardNormal   = { fg = c.fg, bg = c.none },
    SnacksDashboardFooter   = { fg = c.dark_blue, bg = c.bg_d },
    SnacksDashboardFooterAlt= { fg = c.bg_d, bg = c.none },
    SnacksIndentScope       = { fg = c.grey },
    SnacksIndent            = { fg = c.bg3 },
    SnacksDim               = { fg = c.bg3 },
    SnacksNotifierHistoryTitle = { fg = c.orange, underline = true },

    SnacksPicker            = { link = 'NormalFloatFlat' },
    SnacksPickerBorder      = { link = 'FloatBorderFlat' },
    SnacksPickerTitle       = { fg = c.dark_orange, bg = dark_border },
    SnacksPickerPrompt      = { fg = c.green, bg = float_bg },
    SnacksPickerTotals      = { fg = c.grey, bg = float_bg },
    SnacksPickerMatch       = { fg = c.orange },
    SnacksPickerDir         = { fg = c.grey, italic = true },
    SnacksPickerListCursorLine  = { link = 'CursorLine' },

    -- /// Folke collection ///
    FlashMatch                  = { fg = c.fg, bg = c.bg3 },
    FlashLabel                  = { fg = c.black, bg = c.green },
    NoiceMini                   = { bg = '#000000' },
    NoiceFormatConfirmDefault   = { link = 'LazyButton' },
    NoiceVirtualText            = { link = 'DiagnosticLineNrWarn' },
    NoiceVirtualTextAlt         = { fg = c.dim_yellow },
    LazyNormal                  = { link = 'NormalFloatFlat' },
    LazyButton                  = { bg = c.layer, fg = c.fg },
    LazyButtonActive            = { link = 'WildMenu' },
    WhichKeySeparator           = { fg = c.grey },
    WhichKeyBorder              = { fg = normal_bg, bg = cursorling_bg },
    WhichKeyNormal              = { fg = c.fg, bg = cursorling_bg },
    WhichKeyFloat               = { fg = c.fg, bg = cursorling_bg },
    WhichKeyTitle               = { fg = c.muted, bg = normal_bg },
    TreesitterContext           = { bg = context },
    TreesitterContextSeparator  = { bg = c.none, fg = c.grey },
    TreesitterContextLineNumber = { bg = context, fg = c.grey },

    -- /// org ///
    CodeBlock                 = { bg = c.bg_d },
    ['@org.verbatim']         = { link = 'DiagnosticLineNrWarn' },
    ['@org.block.org']        = { fg = c.diff_text },
    ['@markup.list.checked']  = { fg = c.ligh_green },
    ['@markup.link.url']      = { fg = '#8a5cf5', underline = true },
    ['@markup.list']          = { fg = '#8a5cf5' },

    -- /// glance.nvim ///
    GlancePreviewNormal       = { fg = c.fg, bg = c.bg_d },
    GlancePreviewLineNr       = { link = 'LineNr' },
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
    DiffviewDiffDelete        = { bg = c.diff_delete, fg = c.bg_d2 },
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
    NeogitHunkHeader           = { fg = c.black, bg = c.layer },
    NeogitHunkHeaderHighlight  = { fg = c.bg0, bg = '#c3a7e5' },
    NeogitDiffContextHighlight = { bg = cursorling_bg },
    NeogitWinSeparator         = { fg = c.bg3 },

    -- /// neo-tree.nvim ///
    NeoTreeFileIcon      = { fg = c.muted },
    NeoTreeFloatBorder   = { bg = float_bg, fg = c.cyan },
    NeoTreeFloatTitle    = { link = 'FloatBorderTitle' },
    NeoTreeTitleBar      = { link = 'FloatBorderTitle' },
    NeoTreeModified      = { link = 'String' },
    NeoTreeMessage       = { link = 'Comment' },
    NeoTreeDimText       = { link = 'Comment' },
    NeoTreeDirectoryIcon = { link = 'DirectoryIcon' },
    NeoTreeIndentMarker  = { link = 'SnacksIndent' },
    NeoTreeNormal        = { link = 'SidebarDark' },
    NeoTreeNormalNC      = { link = 'SidebarDark' },
    NeoTreeVertSplit     = { link = 'EdgyWinSeparator' },
    NeoTreeWinSeparator  = { link = 'EdgyWinSeparator' },
    NeoTreeFloatNormal   = { link = 'TelescopeNormal' },
    -- NeoTreeCursorLine    = { link = 'CursorLineFocus' },
    -- hi! NeoTreeGitUntracked       gui=NONE

    qfLineNr             = { fg = c.light_grey },
    qfSeparator          = { link = 'Comment' },
    QuickFixHeaderHard   = { link = 'qfSeparator' },
    QuickFixHeaderSoft   = { link = 'qfSeparator' },

    -- /// blink.cmp ///
    BlinkCmpGhostText         = { fg = c.muted },
    BlinkCmpLabel             = { fg = c.fg },
    BlinkCmpLabelMatch        = { fg = c.orange },
    BlinkCmpLabelDeprecated   = { fg = c.muted, strikethrough = true },
    BlinkCmpSource            = { fg = c.grey },
    BlinkCmpMenuBorder        = { link = 'FloatBorderFlat' },
    BlinkCmpDoc               = { link = 'BlinkCmpMenu' },
    BlinkCmpDocBorder         = { link = 'BlinkCmpMenuBorder' },

    BlinkCmpKindFunction      = { fg = c.purple },
    BlinkCmpKindVariable      = { fg = c.blue },
    BlinkCmpKindConstructor   = { fg = c.yellow },
    BlinkCmpKindText          = { fg = c.bg_blue },
    BlinkCmpKindProperty      = { fg = c.light_grey },
    BlinkCmpKindMethod        = { link = 'BlinkCmpKindFunction' },
    BlinkCmpKindModule        = { link = 'BlinkCmpKindFunction' },
    BlinkCmpKindKeyword       = { link = 'BlinkCmpKindFunction' },
    BlinkCmpKindField         = { link = 'BlinkCmpKindVariable' },
    BlinkCmpKindFile          = { link = 'BlinkCmpKindVariable' },
    BlinkCmpKindInterface     = { link = 'BlinkCmpKindVariable' },
    BlinkCmpKindClass         = { link = 'BlinkCmpKindConstructor' },
    BlinkCmpKindEvent         = { link = 'BlinkCmpKindConstructor' },
    BlinkCmpKindStruct        = { link = 'BlinkCmpKindConstructor' },
    BlinkCmpKindEnum          = { link = 'BlinkCmpKindConstructor' },
    BlinkCmpKindEnumMember    = { link = 'BlinkCmpKindConstructor' },
    BlinkCmpKindValue         = { link = 'BlinkCmpKindConstructor' },
    BlinkCmpKindConstant      = { link = 'BlinkCmpKindProperty' },
    BlinkCmpKindTypeParameter = { link = 'BlinkCmpKindProperty' },
    BlinkCmpKindUnit          = { link = 'BlinkCmpKindProperty' },
    BlinkCmpKindOperator      = { link = 'BlinkCmpKindProperty' },
    BlinkCmpKindSnippet       = { link = 'BlinkCmpKindText' },

    -- /// nui.nvim ///
    NuiNormalFloat = { link = 'Normal' },
    NuiFloatBorder = { link = 'FloatBorder' },
    NuiBorderTitle = { link = 'String' },
    NuiMenuItem    = { fg = c.black, bg = c.cyan },

    NuiComponentsCheckboxLabel             = { fg = c.light_grey },
    NuiComponentsCheckboxIcon              = { fg = c.light_grey },
    NuiComponentsCheckboxLabelChecked      = { fg = c.yellow },
    NuiComponentsCheckboxIconChecked       = { fg =  c.yellow },

    NuiComponentsNormal                    = { link = 'SidebarDark' },
    NuiComponentsInfo                      = { fg = c.grey, bg = c.bg_d },
    NuiComponentsTreeSpectreIcon           = { fg = c.grey },
    NuiComponentsTreeSpectreSearchValue    = { bg =  c.layer  },
    NuiComponentsTreeSpectreSearchOldValue = { fg = c.fg, bg = '#501b20', strikethrough = true },
    NuiComponentsTreeSpectreSearchNewValue = { fg = c.fg, bg = '#003e4a' },
    NuiComponentsTreeSpectreReplaceSuccess = { link = 'String' },
    NuiComponentsTreeSpectreCodeLine       = { fg = c.none },
    NuiComponentsTreeSpectreFileName       = { fg = c.purple },
    NuiComponentsTreeNodeFocused           = { link = 'CursorLine' },

    -- /// Mason ///
    MasonNormal                 = { link = 'NormalFloatFlat' },
    MasonMutedBlock             = { link = 'LazyButton' },
    MasonHighlightBlockBold     = { link = 'LazyButtonActive' },

    -- /// vim-visual-multi ///
    VM_Extend                   = { bg = '#363f7d', fg =  c.none  },
    VM_Cursor                   = { bg = '#5962a1', fg = c.none },
    VM_Insert                   = { bg = '#4c4e50', fg = c.none },
    VM_Mono                     = { bg = c.ligh_green, fg = c.white },

    -- /// eyeliner ///
    EyelinerPrimary             = { fg = 'tomato', underline = true },
    EyelinerSecondary           = { fg = '#d78787', underline = true },

    -- /// navbyddy ///
    NavbuddyFile                = { link = '@lsp.type.comment' },
    NavbuddyModule              = { link = '@module' },
    NavbuddyNamespace           = { link = '@lsp.type.Namespace' },
    NavbuddyPackage             = { link = 'Keyword' },
    NavbuddyClass               = { link = '@lsp.type.class' },
    NavbuddyProperty            = { link = '@lsp.type.Property' },
    NavbuddyField               = { link = '@lsp.type.Property' },
    NavbuddyConstructor         = { link = '@type' },
    NavbuddyEnum                = { link = '@lsp.type.Enum' },
    NavbuddyInterface           = { link = '@lsp.type.Interface' },
    NavbuddyFunction            = { link = '@lsp.type.Function' },
    NavbuddyMethod              = { link = '@lsp.type.method' },
    NavbuddyVariable            = { link = '@lsp.type.Variable' },
    NavbuddyConstant            = { link = 'Constant' },
    NavbuddyEnumMember          = { link = '@lsp.type.EnumMember' },
    NavbuddyStruct              = { link = '@lsp.type.Struct' },
    NavbuddyEvent               = { link = '@lsp.type.Event' },
    NavbuddyOperator            = { link = '@lsp.type.Operator' },
    NavbuddyTypeParameter       = { link = '@lsp.type.TypeParameter' },
    NavbuddyString              = { link = '@lsp.type.String' },
    NavbuddyNumber              = { link = '@lsp.type.Number' },
    NavbuddyBoolean             = { link = '@boolean' },
    NavbuddyArray               = { link = '@type' },
    NavbuddyObject              = { link = '@constant.builtin' },
    NavbuddyKey                 = { link = '@constant.builtin' },
    NavbuddyNull                = { link = '@constant.builtin' },
}

  for hlName, option in pairs(highlights) do
    hl(0, hlName, option)
  end

  for group, co in pairs({
    Error = { fg = c.red, title = 'NvimLightRed' },
    Warn = { fg = c.yellow, title = 'NvimLightYellow' },
    Info = { fg = c.cyan, title = 'NvimLightCyan' },
    Debug = { fg = c.blue, title = 'NvimLightBlue' },
    Trace = { fg = c.grey, title = c.grey },
  }) do
    hl(0, 'SnacksNotifier' .. group, { bg = float_bg })
    local border = 'SnacksNotifierBorder' .. group
    hl(0, border, { bg = float_bg, fg = co.fg })
    hl(0, 'SnacksNotifierTitle' .. group, { fg = c.muted, bg = float_bg, underline = true })
    hl(0, 'SnacksNotifierFooter' .. group, { link = 'SnacksNotifierTitle' })
  end

  local links = {
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
    ['@keyword.function.lua'] = '@keyword.function',

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
    hl(0, newgroup, { link = oldgroup, default = false })
  end
end

return {
  colors = c,
  set_custom_highlights = set_custom_highlights,
}
