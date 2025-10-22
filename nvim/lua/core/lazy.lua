local lazypath = _G.plugin_path .. '/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.api.nvim_echo({ { 'Installing lazy.nvim...', 'ErrorMsg' } }, true, {})
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })

  -- vim.api.nvim_echo({ { 'Installing sqlite-lua...', 'ErrorMsg' } }, true, {})
  -- vim.fn.system({ 'bash', '~/dotfiles/scripts/sqlite-lua.sh' })

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
  { import = 'config.completion' },
  { import = 'config.git' },
  { import = 'config.lsp' },
  { import = 'config.mics' },
  { import = 'config.navigation' },
  { import = 'config.writing' },
  { import = 'config.ui' },
  { import = 'config.testing' },
  -- { import = 'config' },
}

if vim.g.vscode then
  spec = {
    { import = 'config.mics' },
  }
end

require('lazy').setup({
  spec = spec,
  concurrency = 3,
  ui = {
    size = { width = 0.6, height = 0.7 },
    border = 'none',
  },
  rocks = { enabled = false },
  git = {
    timeout = 120, -- Kill processes that take more than 2 minutes
  },
  install = { colorscheme = { 'onedark', 'habamax' } },
  change_detection = {
    enabled = true,
    notify = true, -- Get a notification when changes are found
  },
  dev = { path = require('core.state').dev.path },
  performance = {
    cache = { enabled = true },
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
