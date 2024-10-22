return {
  'uga-rosa/ccc.nvim',
  lazy = true,
  cmd = 'CccPick',
  keys = {
    { '<leader>cp', '<cmd>CccPick<cr>', desc = 'Open color picker' },
    { '<leader>cc', '<cmd>CccConvert<cr>', desc = 'Cycle color format' },
  },
  config = function()
    local ccc = require('ccc')
    local mapping = ccc.mapping

    ccc.setup({
      bar_char = '■',
      point_char = '⏽',
      bar_len = 40,
      default_color = '#7321de',
      save_on_quit = true,
      inputs = {
        ccc.input.hsl,
        ccc.input.rgb,
      },
      outputs = {
        ccc.output.hex,
        ccc.output.hex_short,
        ccc.output.css_rgb,
        ccc.output.css_hsl,
      },
      convert = {
        { ccc.picker.hex, ccc.output.css_rgb },
        { ccc.picker.css_rgb, ccc.output.css_hsl },
        { ccc.picker.css_hsl, ccc.output.hex },
      },
      mappings = {
        ['r'] = mapping.cycle_input_mode,
        ['o'] = mapping.cycle_output_mode,
        ['$'] = mapping.set100,
        ['0'] = mapping.set0,
        ['b'] = mapping.decrease10,
        ['w'] = mapping.increase10,
        ['e'] = mapping.increase10,
        ['n'] = mapping.goto_next,
        ['p'] = mapping.goto_prev,
      },
      highlighter = {
        auto_enable = false,
        lsp = false,
      },
    })
  end,
}

-- {
--  c = { '<Plug>ColorConvertCycle', 'Cycle color' },
--  x = { '<Plug>ColorConvertHEX', 'Convert color to HEX' },
--  h = { '<Plug>ColorConvertHSL', 'Convert color to HSL' },
--  r = { '<Plug>ColorConvertRGB', 'Convert color to RGB' },
--  'NTBBloodbath/color-converter.nvim',
-- },
