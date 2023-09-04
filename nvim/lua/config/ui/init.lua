return {
  { 'navarasu/onedark.nvim', lazy = true },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    config = function()
      require('config.ui.web_devicons')
    end,
  },
  {
    'folke/noice.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require('config.ui.noice')
    end,
    dependencies = {
      {
        'folke/which-key.nvim',
        config = function()
          require('config.ui.whichkey')
        end,
      },
    },
  },
  {
    'freddiehaddad/feline.nvim',
    lazy = true,
    event = { 'BufReadPost', 'VeryLazy' },
    config = function()
      require('config.ui.feline')
      require('config.ui.feline_winbar')
    end,
  },
}
