return {
  'nvim-pack/nvim-spectre',
  keys = {
    { '<leader>/r', '<cmd>lua require("hasan.widgets.spectre").open()<cr>', desc = 'Toggle Spectre' },
    { '<leader>/w', '<cmd>lua require("hasan.widgets.spectre").open_visual({select_word=true})<cr>', desc = 'Search current word' },
    { '<leader>/w', '<esc><cmd>lua require("hasan.widgets.spectre").open_visual()<cr>', desc = 'Search current word', mode = 'x' },
    { '<leader>/W', '<cmd>lua require("hasan.widgets.spectre").open_visual({select_word=true,current_file=true})<cr>', desc = 'Search current word' },
    { '<leader>/W', '<esc><cmd>lua require("hasan.widgets.spectre").open_visual({current_file=true})<cr>', desc = 'Search current word', mode = 'x' },
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
