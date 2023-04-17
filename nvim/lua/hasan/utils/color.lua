local cmd = vim.cmd
local M = {}

M.toggle_bg_tranparent = function()
  local statePath = vim.fs.normalize(require('hasan.utils.file').config_root() .. '/lua/core/state.lua')
  local normal = vim.g.onedark_theme_colors[vim.g.onedark_config.style].normal

  if not state.theme.bg_tranparent then
    state.theme.bg_tranparent = true
    -- require('nebulous.view').disable_win_blur()
    cmd(string.format('hi Normal guibg=%s guifg=%s', 'None', normal.fg))
    cmd(string.format("silent !sed -i '22s/false/true/' %s", statePath))
  else
    state.theme.bg_tranparent = false
    -- require('nebulous').init()
    cmd(string.format('hi Normal guibg=%s guifg=%s', normal.bg, normal.fg))
    cmd(string.format("silent !sed -i '22s/true/false/' %s", statePath))
  end
end

M.get_hl = function(name)
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
  if not ok then
    return
  end
  for _, key in pairs({ 'foreground', 'background', 'special' }) do
    if hl[key] then
      hl[key] = string.format('#%06x', hl[key])
    end
  end
  return hl
end

-- Define bg color
-- @param group Group
-- @param color Color
M.bg = function(group, col)
  cmd('hi ' .. group .. ' guibg=' .. col)
end

-- Define fg color
-- @param group Group
-- @param color Color
M.fg = function(group, col)
  cmd('hi ' .. group .. ' guifg=' .. col)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
M.fg_bg = function(group, fgcol, bgcol)
  cmd('hi ' .. group .. ' guifg=' .. fgcol .. ' guibg=' .. bgcol)
end

return M
