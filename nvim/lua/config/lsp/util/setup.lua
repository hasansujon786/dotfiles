local lsp_extras = require('config.lsp.util.extras')

local function server_specific_setup(client, bufnr)
  local g_conf = lsp_extras.get_global_conf()
  local local_conf = lsp_extras.get_server_conf(client.name)

  -- Initialize Local setup ------------------
  if local_conf and local_conf.setup then
    local_conf.setup(client, bufnr)
  end

  -- Disable defalut formatter ---------------
  if g_conf ~= nil and not vim.tbl_contains(g_conf.use_builtin_lsp_formatter, client.name) then
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
    -- eslint = { 'eslint-lsp' },
    gopls = { 'gopls' },
  },
  extra_tools = {
    'stylua',
    'prettierd',
    'dart-debug-adapter',
  },
  use_builtin_lsp_formatter = { 'dartls', 'astro' },
  default_opts = {
    flags = { debounce_text_changes = 500 },
    capabilities = require('config.lsp.util.extras').update_capabilities('lsp-config'),
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    on_attach = function(client, bufnr)
      lsp_autocmds(client)
      server_specific_setup(client, bufnr)
      require('config.lsp.util.keymaps').lsp_buffer_keymaps(client, bufnr)
    end,
  },
}

return M
