local lazypath = _G.plugin_path .. '/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.api.nvim_echo({ { 'Installing lazy.nvim...', 'ErrorMsg' } }, true, {})
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local spec = {
  { import = 'config' },
  { import = 'config.lsp' },
  { import = 'config.git' },
  { import = 'config.ui' },
  { import = 'config.mics' },
  { import = 'config.completion' },
}

if vim.g.vscode then
  spec = {
    { import = 'config.mics' },
  }
end

require('lazy').setup({
  spec = spec,
  concurrency = 3,
  git = {
    timeout = 120, -- kill processes that take more than 2 minutes
  },
  install = { colorscheme = { 'onedark', 'habamax' } },
  change_detection = {
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  dev = { path = 'E:/repoes/lua/' },
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
        'rplugin',
        'man',
        -- 'matchit',
        -- 'matchparen',
      },
    },
  },
})
