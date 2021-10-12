local M = {}

M.toggle_bg_tranparent = function ()
  local theme = vim.g.onedark_theme_colors[vim.g.onedark_style]

  if not vim.g.bg_tranparent then
    vim.g.bg_tranparent = true
    require('nebulous').disable()
    vim.cmd(string.format('hi Normal guibg=%s guifg=%s', 'None', theme.fg))
    vim.cmd[[silent !sed -i '01s/false/true/' ~/dotfiles/nvim/lua/state.lua]]
  else
    vim.g.bg_tranparent = false
    require('nebulous').active()
    vim.cmd(string.format('hi Normal guibg=%s guifg=%s', theme.bg, theme.fg))
    vim.cmd[[silent !sed -i '01s/true/false/' ~/dotfiles/nvim/lua/state.lua]]
  end
end

M.toggle_onedark = function ()
  require('onedark').toggle()
  print(vim.g.onedark_style)
end

return M
