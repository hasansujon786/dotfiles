  -------------------------------------------------------------------
 ----------------------------------------------------------------------
--  Author: Hasan Mahmud                                              --
--  Repo:   https://github.com/hasansujon786/dotfiles/                --
 ----------------------------------------------------------------------
  -------------------------------------------------------------------

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0

if not is_installed then
  if vim.fn.input("Install packer.nvim?") == "y" then
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd 'packadd packer.nvim'
    print(" Installed packer.nvim.")
    is_installed = 1
  end
end

if is_installed then
  require('state')
  require('global')
  require('options')
  require('plugins')
  require('keymaps')
  require('autocmds')
  require('playground')
end
-- nodejs.install
-- https://cj.rs/blog/tips/nvim-plugin-development/

