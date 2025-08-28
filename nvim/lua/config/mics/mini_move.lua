local nx = { 'n', 'x' }

return {
  'nvim-mini/mini.move',
  keys = {
    { '<M-k>', mode = nx, desc = 'Move up' },
    { '<M-j>', mode = nx, desc = 'Move down' },
    { '<M-up>', mode = nx, desc = 'Move up' },
    { '<M-down>', mode = nx, desc = 'Move down' },
    { '<M-left>', mode = nx, desc = 'Move left' },
    { '<M-right>', mode = nx, desc = 'Move right' },
  },
  config = function()
    local map = vim.api.nvim_set_keymap
    map('n', '<M-up>', '<M-k>', { silent = true, desc = 'Move up' })
    map('x', '<M-up>', '<M-k>', { silent = true, desc = 'Move up' })
    map('n', '<M-down>', '<M-j>', { silent = true, desc = 'Move down' })
    map('x', '<M-down>', '<M-j>', { silent = true, desc = 'Move down' })
    require('mini.move').setup({
      mappings = {
        left = '<M-left>',
        right = '<M-right>',
        line_left = '<M-left>',
        line_right = '<M-right>',
        up = '<M-k>',
        down = '<M-j>',
        line_up = '<M-k>',
        line_down = '<M-j>',
      },
    })
  end,
}
