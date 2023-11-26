-- local palette = require('onedark.palette')
local util = require('hasan.utils.color')

local palette = {
  cool = {
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
    light_grey = '#8b95a7',
    -- light_grey = '#7d899f',

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
  },
}

local function set_custom_highlights()
  local normal_bg = palette.cool.bg0
  local fg = palette.cool.fg
  local cursorling_bg = palette.cool.bg1
  local float_bg = '#21252B' -- '#1c212c' palette.cool.bg_d
  local bg3 = palette.cool.bg3

  util.fg_bg('NormalFloat', fg, normal_bg)
  util.fg_bg('FloatBorder', palette.cool.cyan, normal_bg)
  util.fg_bg('NormalFloatFlat', fg, float_bg)
  util.fg_bg('FloatBorderFlat', float_bg, float_bg)
  util.fg_bg('FloatBorderHidden', bg3, normal_bg)

  util.fg('TelescopePromptTitle', palette.cool.orange)
  util.fg_bg('TelescopeSelectionCaret', palette.cool.orange, cursorling_bg)
  util.fg('TelescopeMatching', palette.cool.orange)
  util.fg('TelescopePromptPrefix', palette.cool.green)

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

  vim.fn['hasan#highlight#load_custom_highlight']()

  -- https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/theme.lua#L255-L272
  local links = {
    ['TelescopeSelection'] = 'Cursorline',

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
