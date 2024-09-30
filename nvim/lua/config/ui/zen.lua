local nx = { 'n', 'x' }
local pos = nil

return {
  'folke/zen-mode.nvim',
  lazy = true,
  cmd = 'ZenMode',
  keys = {
    {
      '<leader>z',
      function()
        if require('zen-mode.view').is_open() then
          pos = vim.api.nvim_win_get_cursor(require('zen-mode.view').win)
        end
        require('zen-mode').toggle()
      end,
      mode = nx,
      desc = 'ZenMode',
    },
    {
      '<leader>u',
      function()
        if require('zen-mode.view').is_open() then
          pos = vim.api.nvim_win_get_cursor(require('zen-mode.view').win)
        end

        require('zen-mode').toggle({
          window = { width = 0.6 },
          plugins = {
            wezterm = { enabled = true, font = '6_minimap' },
          },
        })
      end,
      mode = nx,
      desc = 'ZenMode Minimap',
    },
  },
  opts = {
    border = { '', '', '', '│', '', '', '', '│' },
    window = {
      backdrop = 1,
      width = 120,
      height = 1, -- 1 = 100%
      options = {
        signcolumn = 'no', -- disable signcolumn
        scrolloff = 5,
        winbar = '',
        -- statuscolumn = '',
        -- number = false, -- disable number column
        -- relativenumber = false, -- disable relative numbers
      },
    },
    plugins = {
      -- disable global vim options (vim.o...)
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        showcmd = false, -- disables the command in the last line of the screen
        laststatus = 0, -- turn off the statusline in zen mode : 0 / 3
      },
      wezterm = {
        enabled = true,
        font = 0, -- options: 0 18 +4 (10% increase per step)
      },
    },
    -- on_open = function(win)
    --   vim.o.cmdheight = 0
    -- end,
    -- -- callback where you can add custom code when the Zen window closes
    on_close = function()
      if pos == nil then
        return
      end

      vim.defer_fn(function()
        local parent = require('zen-mode.view').parent

        if parent and vim.api.nvim_win_is_valid(parent) then
          vim.api.nvim_set_current_win(parent)
          pcall(vim.api.nvim_win_set_cursor, parent, pos)
          pos = nil
        end
      end, 200)
    end,
  },
}
