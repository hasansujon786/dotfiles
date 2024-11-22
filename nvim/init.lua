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
if vim.g.vscode then
  require('vscode_nvim')
else
  require('core.autocmds')
end
require('core.lazy')
