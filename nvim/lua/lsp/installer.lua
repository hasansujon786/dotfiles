-- { 'williamboman/nvim-lsp-installer', config = function() require('lsp.installer') end },
require('nvim-lsp-installer').setup({ ensure_installed = { 'sumneko_lua' } })
local lspconfig = require('lspconfig')
local M = {
  essential_servers = {
    'bashls',
    'html',
    'vimls',
    'vuels',
    'cssls',
    'jsonls',
    'tsserver',
    'emmet_ls',
    'tailwindcss',
    'sumneko_lua',
  },
}

local opts = {
  on_attach = require('lsp').on_attach,
  flags = {
    debounce_text_changes = 500,
  },
  capabilities = require('lsp.util').update_capabilities(),
}

for _, server_name in pairs(M.essential_servers) do
  if server_name == 'sumneko_lua' then
    lspconfig[server_name].setup(require('hasan.utils').merge(opts, {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim', 'jit', 'keymap', 'P' }, -- Get the language server to recognize the `vim` global
          },
          workspace = {
            library = { -- Make the server aware of Neovim runtime files
              'C:\\Users\\hasan\\dotfiles\\nvim\\lua',
            },
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }))
  else
    lspconfig[server_name].setup(opts)
  end
end

