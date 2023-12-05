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
    eslint = { 'eslint-lsp' },
    gopls = { 'gopls' },
  },
  extra_tools = {
    'stylua',
    'dart-debug-adapter',
  },
  use_builtin_lsp_formatter = { 'dartls', 'astro' },
  default_opts = {
    flags = { debounce_text_changes = 500 },
    capabilities = require('config.lsp.util.setup').update_capabilities('lsp-config'),
    on_attach = require('config.lsp.util.setup').on_attach,
  },
}

return M
