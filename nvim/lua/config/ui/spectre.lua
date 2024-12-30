return {
  'nvim-pack/nvim-spectre',
  keys = {
    { '<leader>/r', '<cmd>lua require("hasan.widgets.spectre").open()<cr>', desc = 'Open Spectre search' },
    { '<leader>/R', '<cmd>lua require("hasan.widgets.spectre").open({current_file=true})<cr>', desc = 'Open Spectr searche' },
    { '<leader>/r', '<esc><cmd>lua require("hasan.widgets.spectre").open_visual()<cr>', desc = 'Search select word', mode = 'x' },
    { '<leader>/R', '<esc><cmd>lua require("hasan.widgets.spectre").open_visual({current_file=true})<cr>', desc = 'Search select word', mode = 'x' },

    { '<leader>/w', '<cmd>lua require("hasan.widgets.spectre").open({select_word=true})<cr>', desc = 'Search current word' },
    { '<leader>/W', '<cmd>lua require("hasan.widgets.spectre").open({select_word=true,current_file=true})<cr>', desc = 'Search current word' },
    { '<leader>/w', '<esc><cmd>lua require("hasan.widgets.spectre").open_visual()<cr>', desc = 'Search select word', mode = 'x' },
    { '<leader>/W', '<esc><cmd>lua require("hasan.widgets.spectre").open_visual({current_file=true})<cr>', desc = 'Search select word', mode = 'x' },
  },
  cmd = 'Spectre',
  opts = {},
  dependencies = {
    {
      'grapp-dev/nui-components.nvim',
      dependencies = {
        'MunifTanjim/nui.nvim',
      },
    },
  },
}
