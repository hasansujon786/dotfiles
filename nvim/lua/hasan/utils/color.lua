local M = {}

M.toggle_bg_tranparent = function ()
  if vim.fn.exists('bg_tranparent') == 0 then
    vim.g.bg_tranparent = false
  end
  if not vim.g.bg_tranparent then
    vim.g.bg_tranparent = true
    vim.cmd('hi Normal guibg=NONE guifg=#ABB2BF')
    vim.fn['nebulous#off']()
  else
    vim.g.bg_tranparent = false
    vim.cmd('hi Normal guibg=#282C34 guifg=#ABB2BF')
    vim.fn['nebulous#on']()
  end

  require('telescope').setup{defaults = {winblend = vim.g.bg_tranparent and 0 or 5}}
end

return M
