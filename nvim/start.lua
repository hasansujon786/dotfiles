
vim.g.disable_lsp = false
vim.g.disable_coc = true
require('global')
require('options')
require('plugins')

if (vim.g.disable_lsp == false) then
  require('lsp')
  require('lsp.tailwindcss-ls')
  require('lsp.sumneko_lua')
end


