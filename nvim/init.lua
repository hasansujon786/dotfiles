----------------------------------------------------------
----------------------------------------------------------
--  Author: Hasan Mahmud                                --
--  Repo:   https://github.com/hasansujon786/dotfiles/  --
----------------------------------------------------------
----------------------------------------------------------

require('core.state')
require('core.global')
require('core.options')
require('core.keymaps')
require('core.commands')
if not vim.g.vscode then
  require('core.autocmds')
  require('core.lazy')
else
  -- require('vscode.keymaps')
end
