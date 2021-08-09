local maps = require('hasan.utils.maps')

vim.cmd[[
nmap <expr> ; sneak#is_sneaking() ? '<Plug>Sneak_;' : ';'
nmap <expr> , sneak#is_sneaking() ? '<Plug>Sneak_,' : ','
xmap <expr> ; sneak#is_sneaking() ? '<Plug>Sneak_;' : ';'
xmap <expr> , sneak#is_sneaking() ? '<Plug>Sneak_,' : ','
]]
-- Repeat the last Sneak
maps.nmap('gs', 's<CR>')
maps.nmap('gS', 'S<CR>')
maps.xmap('gs', 's<CR>')
maps.xmap('gS', 'Z<CR>')
