-- stylua: ignore
return {
    -- /// nvim-cmp ///
    CmpBorder             = { fg = dark_border, bg = float_bg },
    CmpItemMenu           = { fg = c.grey },
    CmpItemAbbrMatchFuzzy = { fg = c.orange, underline = true },
    CmpItemAbbrMatch      = { fg = c.orange },
    CmpItemAbbrDeprecated = { fg = c.muted, strikethrough = true },
    CmpItemKindFunction   = { fg = c.purple },
    CmpItemKindMethod     = { link = 'CmpItemKindFunction' },
    CmpItemKindModule     = { link = 'CmpItemKindFunction' },
    CmpItemKindKeyword    = { link = 'CmpItemKindFunction' },
    CmpItemKindVariable   = { fg = c.blue },
    CmpItemKindFile       = { link = 'CmpItemKindVariable' },
    CmpItemKindField      = { link = 'CmpItemKindVariable' },
    CmpItemKindInterface  = { link = 'CmpItemKindVariable' },
    CmpItemKindClass      = { fg = c.yellow },
    CmpItemKindEvent      = { link = 'CmpItemKindClass' },
    CmpItemKindStruct     = { link = 'CmpItemKindClass' },
    CmpItemKindEnum       = { link = 'CmpItemKindClass' },
    CmpItemKindValue      = { link = 'CmpItemKindClass' },
    CmpItemKindEnumMember = { link = 'CmpItemKindClass' },
    CmpItemKindConstructor= { link = 'CmpItemKindClass' },
    CmpItemKindProperty   = { fg = c.light_grey },
    CmpItemKindConstant   = { link = 'CmpItemKindProperty' },
    CmpItemKindTypeParamet= { link = 'CmpItemKindProperty' },
    CmpItemKindUnit       = { link = 'CmpItemKindProperty' },
    CmpItemKindText       = { fg = c.bg_blue },
    CmpItemKindSnippet    = { fg = c.bg_blue },
  
    -- /// FzfLua ///
    FzfLuaBorder            = { fg = c.grey },
    FzfLuaNormal            = { bg = c.none },
    FzfLuaSearch            = { bg = c.red },
    FzfLuaCursor            = { bg = c.blue },
    FzfLuaFzfMatch          = { bg = 'red' },

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
    PersistedTelescopeDir   = { link = 'DirectoryIcon' },

    -- /// MiniSnippets ///
    MiniSnippetsFinal         = { fg = c.dark_green, bg = c.none },
    MiniSnippetsCurrentReplace= { fg = c.none, bg = c.dim_blue },
    MiniSnippetsCurrent       = { fg = c.none, bg = c.none },
    MiniSnippetsUnvisited     = { fg = c.none, bg = c.none, underline = true },
    MiniSnippetsVisited       = { fg = c.none, bg = c.none, underline = false },

    -- /// outline.nvim ///
    OutlineGuides  = { link = 'SnacksIndent' },
    OutlineCurrent = { fg = c.yellow, underline = true },
}
