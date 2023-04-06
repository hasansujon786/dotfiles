local cmd = vim.cmd
local api = vim.api
local utils = require('hasan.utils')
local M = {}

M.my_nebulous_setup = function()
  require('nebulous').setup({
    -- init_wb_with_disabled = vim.g.bg_tranparent,
    on_focus = function(info, _)
      -- local winid, winnr = info.winid, info.winnr
      require('hasan.utils.ui.cursorline').cursorline_show(info.winid)
    end,
    on_blur = function(info)
      local winid = info.winid
      if not utils.is_floating_win(winid) then
        require('hasan.utils.ui.cursorline').cursorline_hide(winid)
      end
    end,
    dynamic_rules = {
      deactive = function(_)
        if vim.t.diffview_view_initialized then
          return true
        end
        if vim.t.disable_nebulous then
          return true
        end
      end,
    },
    ignore_alternate_win = function(winid, is_float)
      local ft = vim.fn.getwinvar(winid, '&ft')
      if ft == 'noice' then
        return true
      end

      if is_float then
        local win_conf = api.nvim_win_get_config(winid)
        if win_conf.width == 44 and win_conf.height == 12 and win_conf.zindex == 1111 then
          return true
        end
      end

      return false
    end,
  })
end

M.toggle_bg_tranparent = function()
  local normal = vim.g.onedark_theme_colors[vim.g.onedark_config.style].normal

  if not vim.g.bg_tranparent then
    vim.g.bg_tranparent = true
    -- require('nebulous.view').disable_win_blur()
    cmd(string.format('hi Normal guibg=%s guifg=%s', 'None', normal.fg))
    cmd([[silent !sed -i '01s/false/true/' ~/dotfiles/nvim/lua/core/state.lua]])
  else
    vim.g.bg_tranparent = false
    -- require('nebulous').init()
    cmd(string.format('hi Normal guibg=%s guifg=%s', normal.bg, normal.fg))
    cmd([[silent !sed -i '01s/true/false/' ~/dotfiles/nvim/lua/core/state.lua]])
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
