local utils = require('hasan.utils')

local M = {}

M.input = function(defaultText, onConfirm, opts)

  local title = utils.get_default(opts.title, 'New Name')
  local width = utils.get_default(opts.width, 25)
  local height = utils.get_default(opts.height, 1)

  if false then
    return 0
  end

  local win = require('plenary.popup').create(defaultText, {
    title = title,
    style = 'minimal',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    relative = 'cursor',
    borderhighlight = 'FloatBorder',
    titlehighlight = 'Title',
    highlight = 'Float',
    focusable = true,
    width = width,
    height = height,
    -- line = 'cursor+2',
    -- col = 'cursor-1'
  })

  local map_opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(0, 'i', '<Esc>', '<cmd>stopinsert | q!<CR>', map_opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', '<cmd>stopinsert | q!<CR>', map_opts)
  vim.api.nvim_buf_set_keymap(0, 'i', '<CR>', '<cmd>stopinsert | lua _util_ui()<CR>', map_opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<cmd>stopinsert | lua _util_ui()<CR>', map_opts)
  vim.api.nvim_buf_set_option(0, 'filetype', 'Prompt')

  function _G._util_ui()
    local newText = vim.trim(vim.fn.getline('.'))
    vim.api.nvim_win_close(win, true)
    onConfirm(newText)
  end
end

local getInput = function(newText)
  print(newText)
end
local currName = vim.fn.expand('<cword>')
M.input('', getInput, {})

return M
