local nx = { 'n', 'x' }

return {
  'nvim-mini/mini.move',
  enabled = not is_vscode,
  keys = {
    { '<A-k>', mode = nx, desc = 'Move up' },
    { '<A-j>', mode = nx, desc = 'Move down' },

    { '<A-up>', mode = nx, desc = 'Move up' },
    { '<A-down>', mode = nx, desc = 'Move down' },
    { '<A-left>', mode = nx, desc = 'Move left' },
    { '<A-right>', mode = nx, desc = 'Move right' },
  },
  config = function()
    local map = vim.api.nvim_set_keymap
    map('n', '<A-up>', '<A-k>', { silent = true, desc = 'Move up' })
    map('x', '<A-up>', '<A-k>', { silent = true, desc = 'Move up' })
    map('n', '<A-down>', '<A-j>', { silent = true, desc = 'Move down' })
    map('x', '<A-down>', '<A-j>', { silent = true, desc = 'Move down' })
    require('mini.move').setup({
      mappings = {
        up = '<A-k>',
        down = '<A-j>',
        line_up = '<A-k>',
        line_down = '<A-j>',

        left = '<A-left>',
        right = '<A-right>',
        line_left = '<A-left>',
        line_right = '<A-right>',
      },
    })
  end,
}
