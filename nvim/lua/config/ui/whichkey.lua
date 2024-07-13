return {
  'folke/which-key.nvim',
  commit = 'af4ded85542d40e190014c732fa051bdbf88be3d',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    -- require('config.ui.whichkey.config').config()
    require('config.ui.whichkey.config').config_old()
  end,
}
