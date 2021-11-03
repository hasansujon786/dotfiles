  -------------------------------------------------------------------
 ----------------------------------------------------------------------
--  Author: Hasan Mahmud                                              --
--  Repo:   https://github.com/hasansujon786/dotfiles/                --
 ----------------------------------------------------------------------
  -------------------------------------------------------------------

require('state')
require('global')
require('options')
require('plugins')
require('keymaps')
require('autocmds')
-- nodejs.install
-- https://cj.rs/blog/tips/nvim-plugin-development/

-- https://vi.stackexchange.com/questions/22869/how-can-neovim-on-windows-be-configured-to-use-gitbash-as-the-shell-without-brea
vim.cmd[[
if has("win32")
 let &shell='bash.exe'
 let &shellcmdflag = '-c'
 let &shellredir = '>%s 2>&1'
 set shellquote= shellxescape=
 " set noshelltemp
 set shellxquote=
 let &shellpipe='2>&1| tee'
endif
]]
