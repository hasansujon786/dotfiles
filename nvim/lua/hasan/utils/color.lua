local M = {}

M.toggle_bg_tranparent = function ()
  if not vim.g.bg_tranparent then
    vim.g.bg_tranparent = true
    vim.cmd('hi Normal guibg=NONE guifg=#ABB2BF')
    vim.fn['nebulous#off']()
    vim.cmd[[silent !sed -i '01s/false/true/' ~/dotfiles/nvim/lua/state.lua]]
  else
    vim.g.bg_tranparent = false
    vim.cmd('hi Normal guibg=#282C34 guifg=#ABB2BF')
    vim.fn['nebulous#on']()
    vim.cmd[[silent !sed -i '01s/true/false/' ~/dotfiles/nvim/lua/state.lua]]
  end
end

return M
