local nx = { 'n', 'x' }
return {
  'karb94/neoscroll.nvim',
  commit = 'e78657719485c5663b88e5d96ffcfb6a2fe3eec0',
  lazy = true,
  event = 'WinScrolled',
  opts = {},
  keys = {
    { '<C-u>', mode = nx },
    { '<C-d>', mode = nx },
    { 'zt', mode = nx },
    { 'zz', mode = nx },
    { 'zb', mode = nx },
  },
  config = function()
    require('neoscroll').setup()
    local map = {}
    local ease = 'circular'
    map['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '80', ease } }
    map['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '80', ease } }
    map['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250', ease } }
    map['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '250', ease } }
    map['<C-y>'] = { 'scroll', { '-0.10', 'false', '30' } }
    map['<C-e>'] = { 'scroll', { '0.10', 'false', '30' } }
    map['zt'] = { 'zt', { '30' } }
    map['zz'] = { 'zz', { '150' } }
    map['zb'] = { 'zb', { '30' } }
    require('neoscroll.config').set_mappings(map)
  end,
}
