local M = {}

M.toggle_bg_tranparent = function ()
  if vim.fn.exists('bg_tranparent') == 0 then
    vim.g.bg_tranparent = false
  end
  if not vim.g.bg_tranparent then
    vim.g.bg_tranparent = true
    vim.cmd('hi Normal guibg=NONE guifg=#ABB2BF')
    vim.fn['nebulous#off']()
    vim.cmd[[silent !sed -i '01s/v:false/v:true/' ~/dotfiles/nvim/autoload/hasan/highlight.vim]]
  else
    vim.g.bg_tranparent = false
    vim.cmd('hi Normal guibg=#282C34 guifg=#ABB2BF')
    vim.fn['nebulous#on']()
    vim.cmd[[silent !sed -i '01s/v:true/v:false/' ~/dotfiles/nvim/autoload/hasan/highlight.vim]]
  end

  require('telescope').setup{defaults = {winblend = vim.g.bg_tranparent and 0 or 5}}
end

return M
