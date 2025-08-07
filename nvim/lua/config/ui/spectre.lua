local nx = { 'n', 'x' }
return {
  'nvim-pack/nvim-spectre',
  keys = {
    {
      '<leader>/r',
      '<cmd>lua require("hasan.widgets.spectre").open()<cr>',
      mode = nx,
      desc = 'Open Spectre search',
    },
    {
      '<leader>/R',
      '<cmd>lua require("hasan.widgets.spectre").open({current_file=true})<cr>',
      mode = nx,
      desc = 'Open Spectr searche',
    },
    {
      '<leader>/w',
      '<cmd>lua require("hasan.widgets.spectre").open({select_word=true})<cr>',
      mode = nx,
      desc = 'Search current word',
    },
    {
      '<leader>/W',
      '<cmd>lua require("hasan.widgets.spectre").open({select_word=true,current_file=true})<cr>',
      mode = nx,
      desc = 'Search current word',
    },
  },
  cmd = 'Spectre',
  opts = {},
  dependencies = {
    { 'grapp-dev/nui-components.nvim', dependencies = 'MunifTanjim/nui.nvim' },
  },
}
