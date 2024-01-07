local lsp_extras = require('config.lsp.util.extras')

local function load_specific_setup(client, bufnr)
  local g_conf = lsp_extras.get_setup_opts()
  local local_conf = lsp_extras.import_server_local_module(client.name)

  -- Initialize Local setup ------------------
  if local_conf and local_conf.setup then
    local_conf.setup(client, bufnr)
  end

  -- Disable defalut formatter ---------------
  if not vim.tbl_contains(g_conf.use_builtin_lsp_formatter, client.name) then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

local function lsp_autocmds(client)
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved,WinLeave,BufWinLeave,BufLeave <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]])
    --   vim.cmd[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    --   autocmd BufWritePre *.js,*.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
  end
end

local M = {
  essential_servers = { -- Index [1] is to install lsp-server with mason, [2] is for lspconfig
    -- Webdev
    html = { 'html-lsp' },
    cssls = { 'css-lsp' },
    tsserver = { 'typescript-language-server' },
    jsonls = { 'json-lsp' },
    -- Frameworkd
    astro = { 'astro-language-server' },
    volar = { 'vue-language-server' }, -- vuels = { 'vetur-vls' },
    tailwindcss = { 'tailwindcss-language-server' },
    -- Lsps
    bashls = { 'bash-language-server' },
    lua_ls = { 'lua-language-server' },
    vimls = { 'vim-language-server' },
    gopls = { 'gopls' },
    -- Tools
    -- eslint = { 'eslint-lsp' },
  },
  extra_tools = {
    'stylua',
    'eslint_d',
    'prettierd',
    'dart-debug-adapter',
  },
  use_builtin_lsp_formatter = { 'dartls', 'astro', 'null-ls' },
  default_opts = {
    flags = { debounce_text_changes = 500 },
    capabilities = require('config.lsp.util.extras').update_capabilities('setup.lua'),
  },
  onLspAttach = function(client, bufnr)
    require('config.lsp.util.keymaps').lsp_buffer_keymaps(client, bufnr)
    lsp_autocmds(client)
    load_specific_setup(client, bufnr)
  end,
}

return M
