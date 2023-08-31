local M = {
  essential_servers = { -- Index [1] is to install lsp-server with mason, [2] is for lspconfig
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
  },
  extra_tools = {
    'stylua',
  },
  default_opts = {
    on_attach = require('config.lsp.util.setup').on_attach,
    flags = { debounce_text_changes = 500 },
    capabilities = require('config.lsp.util.setup').update_capabilities('lsp-config'),
  },
  use_builtin_lsp_formatter = { 'dartls', 'astro' },
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

M.setup = function()
  local lspconfig = require('lspconfig')
  require('lspconfig.ui.windows').default_options.border = 'rounded'
  for server_name, server_config in pairs(M.essential_servers) do
    if server_config[2] == nil then
      lspconfig[server_name].setup(M.default_opts)
    else
      lspconfig[server_name].setup(require('hasan.utils').merge(M.default_opts, server_config[2]))
    end
  end
end

return M
