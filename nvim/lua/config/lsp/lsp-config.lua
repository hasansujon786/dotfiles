local M = {}
M.essential_servers = { -- [1] is to install lsp-server with mason, [2] is for lspconfig
  bashls = { 'bash-language-server' },
  html = { 'html-lsp' },
  vimls = { 'vim-language-server' },
  vuels = { 'vetur-vls' },
  cssls = { 'css-lsp' },
  jsonls = { 'json-lsp' },
  tsserver = { 'typescript-language-server' },
  tailwindcss = { 'tailwindcss-language-server' },
  lua_ls = { 'lua-language-server' },
  astro = { 'astro-language-server' },
}
M.extra_tools = {
  'stylua',
}

M.essential_servers.lua_ls[2] = {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'jit', 'keymap', 'P' } },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file('', true),
        library = { 'C:\\Users\\hasan\\dotfiles\\nvim\\lua' }, -- Make the server aware of Neovim runtime files
      },
      telemetry = { enable = false },
      -- semantic = { enable = false },
    },
  },
}
M.essential_servers.tailwindcss[2] = {
  root_dir = require('lspconfig.util').root_pattern(
    'tailwind.config.js',
    'tailwind.config.ts',
    'postcss.config.js',
    'postcss.config.ts',
    'package.json',
    'node_modules'
    -- '.git'
  ),
}

function M.update_capabilities()
  local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_ok then
    return cmp_nvim_lsp.default_capabilities()
  end
  vim.notify('cmp_nvim_lsp not loaded with lsp-config', vim.log.levels.WARN)
end

local lspconfig = require('lspconfig')
require('lspconfig.ui.windows').default_options.border = 'rounded'
require('mason').setup({ max_concurrent_installers = 3, ui = { border = 'none', height = 0.8 } })
require('mason-lspconfig').setup()

local default_opts = {
  on_attach = require('config.lsp.setup').on_attach,
  flags = { debounce_text_changes = 500 },
  capabilities = M.update_capabilities(),
}

for server_name, server_config in pairs(M.essential_servers) do
  if server_config[2] == nil then
    lspconfig[server_name].setup(default_opts)
  else
    lspconfig[server_name].setup(require('hasan.utils').merge(default_opts, server_config[2]))
  end
end

return M
