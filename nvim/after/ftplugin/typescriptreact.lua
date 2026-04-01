keymap(
  'n',
  '<leader>ir',
  '<cmd>lua require("hasan.react_props").generate_props_interface()<CR>',
  { buffer = 0, desc = 'Generate React props interface' }
)
