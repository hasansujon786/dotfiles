return {
  'uga-rosa/ccc.nvim',
  lazy = true,
  cmd = 'CccPick',
  keys = {
    { '<leader>cp', '<cmd>CccPick<cr>', desc = 'Open color picker' },
    { 'cp', '<cmd>CccConvert<cr>', desc = 'Cycle color format' },
  },
  config = function()
    local ccc = require('ccc')
    local mapping = ccc.mapping

    ccc.setup({
      bar_char = '■',
      point_char = '⏽',
      bar_len = 40,
      default_color = '#7321de',
      alpha_show = 'hide',
      preserve = true,
      save_on_quit = true,
      inputs = {
        ccc.input.hsl,
        ccc.input.rgb,
        ccc.input.oklch,
      },
      outputs = {
        ccc.output.hex,
        ccc.output.css_hsl,
        ccc.output.css_rgb,
        ccc.output.css_oklch,
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
