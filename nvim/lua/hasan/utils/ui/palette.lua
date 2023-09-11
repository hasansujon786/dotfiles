local palette = require('onedark.palette')
local util = require('hasan.utils.color')

local function set_custom_highlights()
  local normal_bg = palette.cool.bg0
  local fg = palette.cool.fg
  local cursorling_bg = palette.cool.bg1
  local float_bg = '#1c212c' -- palette.cool.bg_d
  local bg3 = palette.cool.bg3

  util.fg_bg('NormalFloat', fg, normal_bg)
  util.fg_bg('FloatBorder', palette.cool.cyan, normal_bg)
  util.fg_bg('NormalFloatFlat', fg, float_bg)
  util.fg_bg('FloatBorderFlat', float_bg, float_bg)
  util.fg_bg('FloatBorderHidden', bg3, normal_bg)

  util.fg('TelescopePromptTitle', palette.cool.orange)
  util.fg_bg('TelescopeSelectionCaret', palette.cool.orange, cursorling_bg)
  util.bg('TelescopeSelection', cursorling_bg)

  util.fg_bg('CmpBorder', '#111925', float_bg)
  util.fg_bg('WhichKeyFloat', fg, cursorling_bg)
  util.fg_bg('WhichKeyBorder ', normal_bg, cursorling_bg)

  -- neo-tree
  local ac = '#2D3343'
  local nc = '#40465b'
  local sp = ac
  util.fg_bg('NeoTreeTabActive', '#ffffff', ac)
  util.fg_bg('NeoTreeTabInactive', '#8b95a7', nc)
  util.fg_bg('NeoTreeTabSeparatorActive', sp, ac)
  util.fg_bg('NeoTreeTabSeparatorInactive', sp, nc)

  vim.fn['hasan#highlight#load_custom_highlight']()

  -- https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/theme.lua#L255-L272
  local links = {
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
