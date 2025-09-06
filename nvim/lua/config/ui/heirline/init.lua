return {
  'rebelot/heirline.nvim',
  lazy = true,
  ft = { 'NeogitStatus', 'gitcommit' },
  event = { 'BufReadPost', 'BufNewFile' },
  -- event = 'UIEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('config.ui.heirline.setup')
  end,
}
