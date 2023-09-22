local lsp_extras = require('config.lsp.util.extras')
local M = {}

function M.server_specific_setup(client, bufnr)
  local g_conf = lsp_extras.get_global_conf()
  local local_conf = lsp_extras.get_server_conf(client.name)

  --------------------------------------------------
  -------- Initialize Local setup ------------------
  --------------------------------------------------
  if local_conf and local_conf.setup then
    local_conf.setup(client, bufnr)
  end

  --------------------------------------------------
  -------- Disable defalut formatter ---------------
  --------------------------------------------------
  if g_conf ~= nil and not vim.tbl_contains(g_conf.use_builtin_lsp_formatter, client.name) then
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

return M
