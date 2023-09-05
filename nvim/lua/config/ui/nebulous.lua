local api = vim.api
local utils = require('hasan.utils')
local M = {
  alternate_winid_to_ignore = nil,
  ignore_alternate_filetypes = { 'noice', 'Outline', 'NvimTree', 'neo-tree' },
}
M.mark_as_alternate_win = function(winid)
  local win = winid or vim.api.nvim_get_current_win()
  M.alternate_winid_to_ignore = win
end

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
      local buf = vim.api.nvim_win_get_buf(winid)
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')

      if vim.tbl_contains(M.ignore_alternate_filetypes, ft) then
        return true
      end

      -- neo-minimap
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

require('hasan.utils').augroup('MY_NEBULOUS_SETUP')(function(autocmd)
  autocmd('FileType', function(info)
    if info.file == 'noice' then
      return
    end

    vim.defer_fn(function()
      if M.alternate_winid_to_ignore ~= nil then
        local winid = M.alternate_winid_to_ignore
        require('nebulous.view').focusWindow(winid)
        require('hasan.utils.ui.cursorline').cursorline_show(winid)
        M.alternate_winid_to_ignore = nil
      end
    end, 10)
  end, { pattern = M.ignore_alternate_filetypes })
end)

M.toggle_symbol_outline = function()
  M.alternate_winid_to_ignore = vim.api.nvim_get_current_win()
  vim.cmd([[SymbolsOutline]])
end

return M
