local cmd = vim.cmd
local api = vim.api
local M = {}

M.my_nebulous_setup = function()
  require('nebulous').setup({
    -- init_wb_with_disabled = vim.g.bg_tranparent,
    on_focus = function(winid)
      require('hasan.utils.ui.cursorline').cursorline_show(winid)
    end,
    on_blur = function(winid)
      require('hasan.utils.ui.cursorline').cursorline_hide(winid)
    end,
  })
end

M.toggle_bg_tranparent = function()
  local normal = vim.g.onedark_theme_colors[vim.g.onedark_config.style].normal

  if not vim.g.bg_tranparent then
    vim.g.bg_tranparent = true
    -- require('nebulous.view').disable_win_blur()
    cmd(string.format('hi Normal guibg=%s guifg=%s', 'None', normal.fg))
    cmd([[silent !sed -i '01s/false/true/' ~/dotfiles/nvim/lua/state.lua]])
  else
    vim.g.bg_tranparent = false
    -- require('nebulous').init()
    cmd(string.format('hi Normal guibg=%s guifg=%s', normal.bg, normal.fg))
    cmd([[silent !sed -i '01s/true/false/' ~/dotfiles/nvim/lua/state.lua]])
  end
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
