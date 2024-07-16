local nx = { 'n', 'x' }
return {
  'folke/which-key.nvim',
  -- commit = 'af4ded85542d40e190014c732fa051bdbf88be3d',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('config.ui.whichkey.config').config()
    -- require('config.ui.whichkey.config').config_old()
  end,
  dependencies = {
    'johmsalas/text-case.nvim',
    lazy = true,
    module = 'textcase',
    config = function()
      require('textcase').setup({ default_keymappings_enabled = true })
    end,
    -- commit = 'ec9925b27dd54809653cc766b8673acd979a888e',
    keys = {
      { 'ga.', '<cmd>TextCaseOpenTelescopeQuickChange<CR>', mode = nx, desc = 'Telescope Quick Change' },
      { 'ga,', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', mode = nx, desc = 'Telescope LSP Change' },
    },
    cmd = {
      'TextCaseOpenTelescope',
      'TextCaseOpenTelescopeQuickChange',
      'TextCaseOpenTelescopeLSPChange',
      'TextCaseStartReplacingCommand',
    },
  },
}
