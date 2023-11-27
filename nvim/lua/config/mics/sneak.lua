-- Repeat the last Sneak
keymap({ 'n', 'x' }, 'gs', '<Plug>Sneak_s<CR>')
keymap({ 'n', 'x' }, 'gS', '<Plug>Sneak_S<CR>')

vim.cmd[[
  hi Sneak guibg=#ccff88 guifg=black gui=bold
  hi! link SneakScope  IncSearch
]]

local function is_sneaking()
  return vim.fn['sneak#is_sneaking']() == 1
end

keymap({ 'n', 'x' }, ';', function()
  return is_sneaking() and '<Plug>Sneak_;' or ';'
end, { expr = true })
keymap({ 'n', 'x' }, ',', function()
  return is_sneaking() and '<Plug>Sneak_,' or ','
end, { expr = true })
