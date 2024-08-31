return {
  'nvim-pack/nvim-spectre',
  keys = {
    { '<leader>/r', '<cmd>lua require("hasan.widgets.spectre").toggle()<cr>', desc = 'Spectre Toggle' },
  },
  cmd = 'Spectre',
  config = function()
    require('spectre').setup()
  end,
  dependencies = {
    {
      'grapp-dev/nui-components.nvim',
      dependencies = { 'MunifTanjim/nui.nvim' },
    },
  },
}
