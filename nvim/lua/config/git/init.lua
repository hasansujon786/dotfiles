return {
  {
    'NeogitOrg/neogit',
    lazy = true,
    cmd = 'Neogit',
    commit = 'f51183a',
    config = function()
      require('config.git.neogit')
    end,
    dependencies = {
      {
        'sindrets/diffview.nvim',
        config = function()
          require('config.git.diffview')
        end,
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require('config.git.gitsigns')
    end,
  },
}
