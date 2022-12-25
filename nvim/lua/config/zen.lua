require('zen-mode').setup({
  window = {
    backdrop = 0.94,
    width = 0.75,
    height = 1, -- 1 = 100%
    options = {
      signcolumn = 'no', -- disable signcolumn
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
    },
  },
  -- on_open = function(win)
  --   vim.o.cmdheight = 0
  -- end,
  -- -- callback where you can add custom code when the Zen window closes
  -- on_close = function()
  --   vim.o.cmdheight = 1
  -- end,
})
