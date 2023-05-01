local api = vim.api
local utils = require('hasan.utils')
local M = {}

keymap('n', '<leader>R', '<cmd>lua require("nebulous").toggle_win_blur()<CR>', { desc = 'Toggle Nebulous' })

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
        if win_conf.width == 44 and win_conf.height == 15 and win_conf.zindex == 1111 then
          return true
        end
      end

      return false
    end,
  })
end

return M
