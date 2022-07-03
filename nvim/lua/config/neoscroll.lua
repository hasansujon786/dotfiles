-- use { 'declancm/cinnamon.nvim', config = function() require('config.cinnamon') end }
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

keymap({ 'n', 'v' }, '<ScrollWheelUp>', '<C-y><C-y>')
keymap({ 'n', 'v' }, '<ScrollWheelDown>', '<C-e><C-e>')

require('neoscroll.config').set_mappings(map)
