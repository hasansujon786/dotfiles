local cmd = vim.cmd
local M = {}

M.toggle_bg_tranparent = function ()
  local normal = vim.g.onedark_theme_colors[vim.g.onedark_config.style].normal

  if not vim.g.bg_tranparent then
    vim.g.bg_tranparent = true
    require('nebulous').disable_win_blur()
    vim.cmd(string.format('hi Normal guibg=%s guifg=%s', 'None', normal.fg))
    vim.cmd[[silent !sed -i '01s/false/true/' ~/dotfiles/nvim/lua/state.lua]]
  else
    vim.g.bg_tranparent = false
    require('nebulous').init()
    vim.cmd(string.format('hi Normal guibg=%s guifg=%s', normal.bg, normal.fg))
    vim.cmd[[silent !sed -i '01s/true/false/' ~/dotfiles/nvim/lua/state.lua]]
  end
end

M.toggle_onedark = function ()
  require('onedark').toggle()
  print(vim.g.onedark_style)
end

-- Define bg color
-- @param group Group
-- @param color Color
M.bg = function(group, col)
   cmd("hi " .. group .. " guibg=" .. col)
end

-- Define fg color
-- @param group Group
-- @param color Color
M.fg = function(group, col)
   cmd("hi " .. group .. " guifg=" .. col)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
M.fg_bg = function(group, fgcol, bgcol)
   cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

return M
