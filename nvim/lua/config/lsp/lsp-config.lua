local M = {
  -- Index [1] is to install lsp-server with mason, [2] is for lspconfig
  essential_servers = {
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
    on_attach = require('config.lsp.setup').on_attach,
    flags = { debounce_text_changes = 500 },
    capabilities = require('config.lsp.setup').update_capabilities(),
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

return M
