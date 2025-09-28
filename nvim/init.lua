----------------------------------------------------------
----------------------------------------------------------
--  Author: Hasan Mahmud                                --
--  Repo:   https://github.com/hasansujon786/dotfiles/  --
----------------------------------------------------------
----------------------------------------------------------

if not vim.g.vscode then
  require('core.state')
  require('core.global')
  require('core.options')
  require('core.commands')
  require('core.keymaps.nvim')
  require('core.autocmds')
  require('core.lazy')
else
  require('core.keymaps.code')
  -- require('vscode.keymaps')
end
