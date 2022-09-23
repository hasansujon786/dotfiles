local ccc = require('ccc')
local mapping = ccc.mapping

ccc.setup({
  bar_char = 'ﱢ',
  point_char = '◇',
  bar_len = 40,
  default_color = '#7321de',
  save_on_quit = true,
  inputs = {
    ccc.input.hsl,
    ccc.input.rgb,
  },
  mappings = {
    ['r'] = mapping.toggle_input_mode,
    ['o'] = mapping.toggle_output_mode,
    ['$'] = mapping.set100,
    ['0'] = mapping.set0,
    ['b'] = mapping.decrease10,
    ['w'] = mapping.increase10,
    ['e'] = mapping.increase10,
    ['n'] = mapping.goto_next,
    ['p'] = mapping.goto_prev,
  },
})

-- use({ 'ziontee113/color-picker.nvim', config = [[require('config.color-picker')]], opt = true, cmd = 'PickColor' })
-- require('color-picker').setup({
--   ['icons'] = { 'ﱢ', '' },
--   ['text_highlight_group'] = 'WhiteText',
-- })
