-- use({ 'hasansujon786/2048.nvim' })
-- { 'folke/zen-mode.nvim', lazy = true, cmd = 'ZenMode', config = function() require('config.zen') end },
-- { 'epwalsh/obsidian.nvim', config = function() require('config.obsidian') end },
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
  },
  -- config = function()
  --   require('config.zen')
  -- end,
}