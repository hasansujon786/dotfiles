local lazypath = _G.plugin_path .. '/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  print('Installing lazy.nvim...................')
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
  vim.fn.system({ 'git', '-C', lazypath, 'checkout', 'tags/stable' }) -- last stable release
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('core.plug', {
  concurrency = 10,
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
