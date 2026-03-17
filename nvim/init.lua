----------------------------------------------------------
----------------------------------------------------------
--  Author: Hasan Mahmud                                --
--  Repo:   https://github.com/hasansujon786/dotfiles/  --
----------------------------------------------------------
----------------------------------------------------------

require('core.state')
require('core.global')
if not vim.g.vscode then
  require('core.options')
  require('core.commands')
  require('core.keymaps.nvim')
  require('core.autocmds')
else
  require('core.keymaps.code')
  require('hasan.utils.ui.palette').set_custom_highlights()
  -- require('vscode.keymaps')
end
require('core.lazy')
