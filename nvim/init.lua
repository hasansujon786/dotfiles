----------------------------------------------------------
----------------------------------------------------------
--  Author: Hasan Mahmud                                --
--  Repo:   https://github.com/hasansujon786/dotfiles/  --
----------------------------------------------------------
----------------------------------------------------------

require('core.state')
require('core.global')
if not is_vscode then
  require('core.options')
  require('core.commands')
else
  require('hasan.utils.ui.palette').set_custom_highlights()
end
require('core.autocmds')
require('core.keymaps')
require('core.lazy')
