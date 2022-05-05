require('neoscroll').setup()
local map = {}

map['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '80' } }
map['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '80' } }
map['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '250' } }
map['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250' } }
map['<C-y>'] = { 'scroll', { '-0.10', 'false', '30' } }
map['<C-e>'] = { 'scroll', { '0.10', 'false', '30' } }
map['zt'] = { 'zt', { '30' } }
map['zz'] = { 'zz', { '150' } }
map['zb'] = { 'zb', { '30' } }

require('neoscroll.config').set_mappings(map)
