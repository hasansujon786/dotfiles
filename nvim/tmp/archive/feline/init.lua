return {
  'freddiehaddad/feline.nvim',
  lazy = true,
  enabled = false,
  event = { 'BufReadPost', 'VeryLazy' },
  config = function()
    require('config.ui.feline.feline')
    require('config.ui.feline.feline_winbar')
  end,
}
