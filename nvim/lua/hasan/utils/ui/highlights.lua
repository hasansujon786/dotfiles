local M = {}

M.apply_custom_hightlights = function ()
  local ok, onedark = pcall(require, 'onedark.colors')
  if not ok then return end

  local color = require('hasan.utils.color')
  local bg = color.bg
  local fg = color.fg
  local fg_bg = color.fg_bg


  local float_bg = onedark.bg_d

  fg_bg("TelescopeBorder", '#3B4048', float_bg)
  fg_bg("TelescopePromptNormal", onedark.fg, float_bg)
  fg_bg("TelescopePromptTitle", onedark.red, float_bg)
  fg("TelescopePromptPrefix", onedark.green)
  fg("TelescopePreviewTitle", onedark.grey)
  fg("TelescopeResultsTitle", onedark.grey)
  bg("TelescopeSelection", onedark.bg1)
  bg("TelescopeNormal", float_bg)
end

return M
