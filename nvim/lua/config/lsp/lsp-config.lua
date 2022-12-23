local lspconfig = require('lspconfig')
require('mason').setup({ max_concurrent_installers = 3, ui = { border = 'rounded' } })
require('lspconfig.ui.windows').default_options.border = 'rounded'
require('mason-lspconfig').setup()
local M = {}

function M.update_capabilities()
  local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_ok then
    P('update_capabilities ok')
    return cmp_nvim_lsp.default_capabilities()
  end
  vim.notify('cmp_nvim_lsp not loaded with lsp-config', vim.log.levels.WARN)
end

local lua_opts = {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'jit', 'keymap', 'P' } },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file('', true),
        library = { 'C:\\Users\\hasan\\dotfiles\\nvim\\lua' }, -- Make the server aware of Neovim runtime files
      },
      telemetry = { enable = false },
    },
  },
}

-- index [1] is for lspconfig & [2] is to install lsp-server with mason
M.essential_servers = {
  { 'bashls', 'bash-language-server' },
  { 'html', 'html-lsp' },
  { 'vimls', 'vim-language-server' },
  { 'vuels', 'vetur-vls' },
  { 'cssls', 'css-lsp' },
  { 'jsonls', 'json-lsp' },
  { 'tsserver', 'typescript-language-server' },
  { 'tailwindcss', 'tailwindcss-language-server' },
  { 'sumneko_lua', 'lua-language-server', lua_opts },
  { 'astro', 'astro-language-server' },
  -- { 'emmet_ls', 'emmet-ls' },
}

local default_opts = {
  on_attach = require('config.lsp.setup').on_attach,
  flags = { debounce_text_changes = 500 },
  capabilities = M.update_capabilities(),
}

for _, server_name in pairs(M.essential_servers) do
  if server_name[3] == nil then
    lspconfig[server_name[1]].setup(default_opts)
  else
    lspconfig[server_name[1]].setup(require('hasan.utils').merge(default_opts, server_name[3]))
  end
end

return M
