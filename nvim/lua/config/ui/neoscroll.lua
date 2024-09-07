local modes = { 'n', 'x' }
return {
  'karb94/neoscroll.nvim',
  -- commit = 'e78657719485c5663b88e5d96ffcfb6a2fe3eec0',
  lazy = true,
  event = 'WinScrolled',
  keys = {
    { '<C-u>', mode = modes },
    { '<C-d>', mode = modes },
    { '<C-f>', mode = modes },
    { '<C-b>', mode = modes },
    { '<C-y>', mode = modes },
    { '<C-e>', mode = modes },
    { 'zt', mode = modes },
    { 'zz', mode = modes },
    { 'zb', mode = modes },
  },
  config = function()
    local neoscroll = require('neoscroll')
    neoscroll.setup({
      mappings = {},
      hide_cursor = true,
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing = 'circular',
    })
    local keymap = {
      ['<C-u>'] = function() neoscroll.ctrl_u({ duration = 250 }) end,
      ['<C-d>'] = function() neoscroll.ctrl_d({ duration = 250 }) end,
      ['<C-b>'] = function() neoscroll.ctrl_b({ duration = 250 }) end,
      ['<C-f>'] = function() neoscroll.ctrl_f({ duration = 250 }) end,
      ['<C-y>'] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 80 }) end,
      ['<C-e>'] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 80 }) end,
      ['zt'] = function() neoscroll.zt({ half_win_duration = 80 }) end,
      ['zz'] = function() neoscroll.zz({ half_win_duration = 80 }) end,
      ['zb'] = function() neoscroll.zb({ half_win_duration = 80 }) end,
    }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
