local popup = require('plenary.popup')
local M = {}

local function create_popup(bufnr, cb)
  local config = {}
  local width = config.width or 80
  local height = config.height or 20
  -- local borderchars = config.borderchars
  --   or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

  local main_win_id, win = popup.create(bufnr, {
    -- relative= 'editor',
    title = 'Fedit',
    highlight = 'Float',
    -- line = math.floor((vim.o.lines - height) / 2) + 2,
    -- col = math.floor((vim.o.columns - width) / 2),
    line = 0,
    col = 0,
    minwidth = width,
    minheight = height,
    maxheight = height,
    -- borderchars = borderchars,
    border = true,
    focusable = true,
  })

  vim.api.nvim_win_set_option( win.border.win_id, 'winhl', 'Normal:FloatBorder')
  cb(win)

  return { win_id = main_win_id }
end


M.fedit = function (fname)
  if vim.fn.filereadable(fname) ~= 1 then
    print(vim.fn.filereadable(fname))
    return 0
  end
  local bufnr = vim.fn.bufadd(fname)

  create_popup(bufnr, function (win)
    -- vim.api.nvim_win_set_option(win.win_id, 'signcolumn', 'no')
    vim.api.nvim_win_set_option(win.win_id, 'number', true)
    vim.api.nvim_win_set_option(win.win_id, 'relativenumber', true)

    vim.cmd[[filetype detect]]

    local cmd_text = 'au WinLeave * ++once lua require("hasan.float").fedit_close_window(%s, %s, %s)'
    vim.cmd(string.format(cmd_text, win.win_id, win.border.win_id, bufnr))
  end)
end

M.fedit_close_window = function(winId, borderWinId, bufnr)
  vim.api.nvim_win_close(winId, false)
  vim.api.nvim_win_close(borderWinId, true)
  vim.cmd('bdelete '..bufnr)
end

return M
