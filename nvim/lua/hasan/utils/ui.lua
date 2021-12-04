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
  vim.api.nvim_buf_set_keymap(0, 'i', '<CR>', '<cmd>stopinsert | lua _utils_ui_input()<CR>', map_opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<cmd>stopinsert | lua _utils_ui_input()<CR>', map_opts)
  vim.api.nvim_buf_set_option(0, 'buftype', 'prompt')

  function _G._utils_ui_input()
    local newText = vim.trim(vim.fn.getline('.'))
    vim.api.nvim_win_close(win, true)
    onConfirm(newText)
  end
end



M.rename_current_file = function ()
  local currNameFileName = vim.fn.expand('%:t')
  local stringlenght = string.len(currNameFileName) + 5

  M.input(currNameFileName, function(newName)
    print(newName)
    vim.cmd('Rename '.. newName)
  end, {
    title = 'Rename File',
    width = stringlenght > 20 and stringlenght or 20,
  })
end

M.substitute_word = function (isVisual)
  local curWord = isVisual and vim.fn['hasan#utils#get_visual_selection']() or vim.fn.expand('<cword>')
  local stringlenght = string.len(curWord) + 5

  M.input(curWord, function(newWord)
    local cmd = isVisual and '%s/'..curWord..'/'..newWord..'/gc' or '%s/\\<'..curWord..'\\>/'..newWord..'/gc'

    vim.fn['hasan#utils#feedkeys'](':<C-u>'..cmd..'<CR>', 'n')
    vim.fn.setreg('z', cmd)
  end, { title = 'Substitute Word', width = stringlenght > 20 and stringlenght or 20 })
end

return M
-- require('hasan.utils.ui').rename_current_file()
