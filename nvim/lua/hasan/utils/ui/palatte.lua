local palatte = require('onedark.palette')
local util = require('hasan.utils.color')

local function set_custom_highlights()
  local normal_bg = palatte.cool.bg0
  local fg = palatte.cool.fg
  local cursorling_bg = palatte.cool.bg1
  local float_bg = palatte.cool.bg_d
  -- float_bg = '#1c212c' -- choice 1

  util.fg_bg('NormalFloat', fg, normal_bg)
  util.fg_bg('FloatBorder', palatte.cool.cyan, normal_bg)
  util.fg_bg('NormalFloatFlat', fg, float_bg)
  util.fg_bg('FloatBorderFlat', float_bg, float_bg)

  util.fg('TelescopePromptTitle', palatte.cool.orange)
  util.fg_bg('TelescopeSelectionCaret', palatte.cool.orange, cursorling_bg)
  util.bg('TelescopeSelection', cursorling_bg)

  vim.fn['hasan#highlight#load_custom_highlight']()
end

return {
  set_custom_highlights = set_custom_highlights,
}
