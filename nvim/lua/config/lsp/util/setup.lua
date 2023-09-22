local M = {}

function M.server_specific_setup(client, bufnr)
  local local_conf = require('config.lsp.util.extras').get_server_conf(client.name)

  if local_conf and local_conf.setup then
    local_conf.setup(client, bufnr)
  end

  if not vim.tbl_contains(require('config.lsp.util.configs').use_builtin_lsp_formatter, client.name) then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

function M.lsp_autocmds(client)
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

function M.update_capabilities(fname)
  local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_ok then
    return cmp_nvim_lsp.default_capabilities()
  end
  vim.notify(fname .. ': cmp_nvim_lsp not loaded with lsp-config', vim.log.levels.WARN)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.on_attach(client, bufnr)
  M.lsp_autocmds(client)
  M.server_specific_setup(client, bufnr)
  require('config.lsp.util.keymaps').lsp_buffer_keymaps(client, bufnr)
end

function M.init_lspconfig()
  local lspconfig = require('lspconfig')
  require('lspconfig.ui.windows').default_options.border = 'rounded'

  -- default lsp configs
  local global_conf = require('config.lsp.util.configs')

  for server_name, _ in pairs(global_conf.essential_servers) do
    local local_conf = require('config.lsp.util.extras').get_server_conf(server_name)
    if local_conf == nil or local_conf.lsp_config == nil then
      lspconfig[server_name].setup(global_conf.default_opts)
    else
      local opts = require('hasan.utils').merge(global_conf.default_opts, local_conf.lsp_config)
      lspconfig[server_name].setup(opts)
    end
  end
end

return M
