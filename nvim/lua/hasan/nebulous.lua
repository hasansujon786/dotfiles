local api = vim.api
local utils = require('hasan.utils')
local M = {
  alternate_winid_to_ignore = nil,
  skip_update_on_focus_ft = { 'neo-tree-popup' },
  ignore_alt_win_ft = { 'noice', 'Outline', 'NvimTree', 'Glance', 'neo-tree', 'flutterToolsOutline', 'log' },
}
M.mark_as_alternate_win = function(winid)
  local win = winid or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.api.nvim_buf_get_option(buf, 'filetype')

  if not vim.tbl_contains(M.ignore_alt_win_ft, ft) then
    M.alternate_winid_to_ignore = win
  end
end
-- lua P(require('hasan.nebulous').alternate_winid_to_ignore)

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
        if vim.t['diffview_view_initialized'] then
          return true
        end
        if vim.t['disable_nebulous'] then
          return true
        end
      end,
    },
    filter = function(winid, is_float)
      local buf = vim.api.nvim_win_get_buf(winid)
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')

      if vim.tbl_contains(M.ignore_alt_win_ft, ft) or vim.tbl_contains(M.skip_update_on_focus_ft, ft) then
        return true
      end

      if is_float then
        -- glance
        if vim.w['glance_preview_window'] then
          return true
        end

        -- neo-minimap
        local win_conf = api.nvim_win_get_config(winid)
        if
          win_conf.width == state.neominimap.width
          and win_conf.height == state.neominimap.height
          and win_conf.zindex == 1111
        then
          return true
        end
      end

      return false
    end,
    nb_blur_hls = {
      -- numbers
      'LineNr:Nebulous',
      'LineNrAbove:Nebulous',
      'LineNrBelow:Nebulous',
      -- Other highlights
      'Comment:NebulousItalic', -- flutter closing tags
      'Conceal:Nebulous',
      'NonText:NebulousInvisibe',
      -- Indent line
      'IblIndent:NebulousDarker',
      'FlutterWidgetGuides:NebulousDarker',
      -- Git
      'GitSignsAdd:NebulousInvisibe',
      'GitSignsChange:NebulousInvisibe',
      'GitSignsDelete:NebulousInvisibe',
      'GitSignsDelete:NebulousInvisibe',
      'GitSignsChange:NebulousInvisibe',
      'GitGutterAdd:NebulousInvisibe',
      'GitGutterChange:NebulousInvisibe',
      'GitGutterDelete:NebulousInvisibe',
    },
  })
end

local function remove_blur_alt()
  vim.defer_fn(function()
    local winid = M.alternate_winid_to_ignore
    if winid ~= nil then
      require('nebulous.view').focusWindow(winid)
      require('hasan.utils.ui.cursorline').cursorline_show(winid)
      -- M.alternate_winid_to_ignore = nil
    end
  end, 10)
end

augroup('MY_NEBULOUS_SETUP')(function(autocmd)
  autocmd('FileType', function(info)
    -- If noice or vinegar win then skip
    if info.file == 'noice' or require('config.neo_tree').vinegar_helper.isNeoTreeWindow(info.file) then
      return
    end

    remove_blur_alt()
  end, { pattern = M.ignore_alt_win_ft })
end)

return M
