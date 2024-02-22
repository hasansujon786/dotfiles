return {
  'hasansujon786/zen-mode.nvim', -- FORK: feat(border): add border to main window
  branch = 'win-border',
  lazy = true,
  cmd = 'ZenMode',
  opts = {
    border = { '', '', '', '│', '', '', '', '│' },
    window = {
      backdrop = 1,
      width = 0.75,
      height = 1, -- 1 = 100%
      options = {
        signcolumn = 'no', -- disable signcolumn
        scrolloff = 5,
        winbar = '',
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
    -- on_close = function()
    --   vim.o.cmdheight = 1
    -- end,
  },
}
