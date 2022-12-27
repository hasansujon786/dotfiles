local lazypath = _G.plugin_path .. '/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  P('Install lazy.nvim')
  local lazyURL = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--single-branch', lazyURL, lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('core.plug', {
  install = { colorscheme = { 'onedark', 'habamax' } },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
