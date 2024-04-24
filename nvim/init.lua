----------------------------------------------------------
----------------------------------------------------------
--  Author: Hasan Mahmud                                --
--  Repo:   https://github.com/hasansujon786/dotfiles/  --
----------------------------------------------------------
----------------------------------------------------------

require('core.state')
require('core.global')
if vim.g.vscode then
  require('vscode.keymaps')
else
  require('core.options')
  require('core.keymaps')
  require('core.autocmds')
end
require('core.lazy')
