require('zen-mode').setup({
  window = {
    backdrop = 1,
    width = 0.75,
    height = 0.85, -- 1 = 100%
    options = {
      signcolumn = 'no', -- disable signcolumn
      -- number = false, -- disable number column
      -- relativenumber = false, -- disable relative numbers
    },
  },
  plugins = {
    -- disable some global vim options (vim.o...)
    -- comment the lines to not apply the options
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
  },
})
