local M = {}

---LspAttach event callback
---@param args table
function M.lsp_attach(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if client == nil then
    return
  end

  local lsp_state = require('core.state').lsp
  local local_conf = require('config.lsp.util.extras').import_lspconfig_by_name(client.name)

  require('config.lsp.util.keymaps').lsp_buffer_keymaps(client, bufnr)

  -- Initialize local lsp_attach ------------------
  if local_conf and local_conf.lsp_attach then
    local_conf.lsp_attach(client, bufnr)
  end

  -- Disable defalut formatter ---------------
  local should_disable_formatter = lsp_state.use_builtin_lsp_formatter ~= nil
    and not vim.tbl_contains(lsp_state.use_builtin_lsp_formatter, client.name)
  if should_disable_formatter then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

function M.update_capabilities(fname)
  local blink_ok, blink_cmp = pcall(require, 'blink.cmp')
  if blink_ok then
    return blink_cmp.get_lsp_capabilities(nil, true)
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_ok then
    return vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
  end

  vim.notify('Capabilities not updated with ' .. fname, vim.log.levels.WARN, { title = 'lsp-config' })
  return capabilities
end

function M.get_setup_opts(lsp_name)
  local local_conf = require('config.lsp.util.extras').import_lspconfig_by_name(lsp_name)

  local default_opts = require('core.state').lsp.default_opts
  default_opts.capabilities = require('config.lsp.util.setup').update_capabilities('setup.lua')

  if local_conf == nil then
    return default_opts
  end

  return vim.tbl_deep_extend('force', default_opts, local_conf.opts)
end

return M
