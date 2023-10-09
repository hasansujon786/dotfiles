local lazypath = _G.plugin_path .. '/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  print('Installing lazy.nvim...................')
  local repo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', repo, '--branch=stable', lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'config' },
    { import = 'config.lsp' },
    { import = 'config.git' },
    { import = 'config.ui' },
    { import = 'config.completion' },
  },
  concurrency = 5,
  git = {
    timeout = 120, -- kill processes that take more than 2 minutes
  },
  install = { colorscheme = { 'onedark', 'habamax' } },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        -- 'matchit',
        -- 'matchparen',
      },
    },
  },
})
