return {
  'nvim-pack/nvim-spectre',
  keys = {
    { '<leader>/r', '<cmd>lua require("hasan.widgets.spectre").open()<cr>', desc = 'Toggle Spectre' },
    {
      '<leader>/R',
      '<cmd>lua require("hasan.widgets.spectre").open_file_search({select_word=true})<cr>',
      desc = 'Search on current file',
    },
    {
      '<leader>/w',
      '<cmd>lua require("hasan.widgets.spectre").open_visual({select_word=true})<cr>',
      desc = 'Search current word',
    },
    {
      '<leader>/w',
      '<esc><cmd>lua require("hasan.widgets.spectre").open_visual()<cr>',
      desc = 'Search current word',
      mode = 'x',
    },
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
