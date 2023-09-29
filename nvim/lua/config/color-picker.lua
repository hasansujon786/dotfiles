-- use({ 'ziontee113/color-picker.nvim', config = [[require('config.color-picker')]], opt = true, cmd = 'PickColor' })
-- require('color-picker').setup({
--   ['icons'] = { 'ﱢ', '' },
--   ['text_highlight_group'] = 'WhiteText',
-- })
return {
  'uga-rosa/ccc.nvim',
  lazy = true,
  cmd = 'CccPick',
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
      highlighter = {
        auto_enable = false,
        lsp = false,
      },
    })
  end,
}
