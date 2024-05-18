local lsp_extras = require('config.lsp.util.extras')

---@type LspAttachCb
local function load_specific_setup(client, bufnr)
  local g_conf = lsp_extras.get_setup_opts()
  local local_conf = lsp_extras.import_server_local_module(client.name)

  -- Initialize Local setup ------------------
  if local_conf and local_conf.setup then
    local_conf.setup(client, bufnr)
  end

  -- Disable defalut formatter ---------------
  local should_disable_formatter = g_conf.use_builtin_lsp_formatter ~= nil
    and not vim.tbl_contains(g_conf.use_builtin_lsp_formatter, client.name)
  if should_disable_formatter then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

---@type LspAttachCb
local function lsp_autocmds(client, bufnr)
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
  -- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'InsertLeave' }, {
  --   pattern = '*',
  --   callback = function()
  --     vim.notify('codelens active')
  --     -- lsp.CodeLens
  --     vim.lsp.codelens.refresh({ bufnr = 0 })
  --   end,
  -- })
  -- vim.api.nvim_create_autocmd('LspDetach', {
  --   callback = function(opt)
  --     vim.lsp.codelens.clear(opt.data.client_id, opt.buf)
  --   end,
  -- })
  -- local bufopts = { noremap = true, silent = true, buffer = bufnr }
  -- vim.keymap.set('n', '<leader>la', vim.lsp.codelens.run, bufopts)
end

local M = {
  essential_servers = { -- Index [1] is to install lsp-server with mason, [2] is for lspconfig
    -- Frontend
    html = { 'html-lsp' },
    cssls = { 'css-lsp' },
    tsserver = { 'typescript-language-server' },
    jsonls = { 'json-lsp' },
    eslint = { 'eslint-lsp' },
    -- Frameworks
    astro = { 'astro-language-server' },
    volar = { 'vue-language-server' }, -- vuels = { 'vetur-vls' },
    tailwindcss = { 'tailwindcss-language-server' },
    -- Lsps
    bashls = { 'bash-language-server' },
    lua_ls = { 'lua-language-server' },
    vimls = { 'vim-language-server' },
    gopls = { 'gopls' },
  },
  extra_tools = {
    'shfmt',
    'shellcheck',
    'stylua',
    'prettierd',
    'dart-debug-adapter',
  },
  -- use_builtin_lsp_formatter = { 'dartls', 'astro', 'null-ls' },
  default_opts = {
    flags = { debounce_text_changes = 500 },
    capabilities = require('config.lsp.util.extras').update_capabilities('setup.lua'),
  },
  ---@type LspAttachCb
  onLspAttach = function(client, bufnr)
    require('config.lsp.util.keymaps').lsp_buffer_keymaps(client, bufnr)
    lsp_autocmds(client, bufnr)
    load_specific_setup(client, bufnr)
  end,
}

return M
