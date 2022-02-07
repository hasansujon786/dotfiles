local M = {}
local ui = require('state').ui

require('lsp.diagnosgic').setup()
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = ui.border.style }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = ui.border.style }
)

local function lsp_document_highlight(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
      ]], false)
    -- autocmd BufWritePre *.js,*.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
  end
end

local function lsp_buffer_keymaps(client, bufnr)
  local function buf_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_map('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_map('n', 'gpd', '<cmd>lua require"lsp.peek".PeekDefinition()<CR>', opts)
  buf_map('n', 'gpy', '<cmd>lua require"lsp.peek".PeekTypeDefinition()<CR>', opts)
  buf_map('n', 'gpI', '<cmd>lua require"lsp.peek".PeekImplementation()<CR>', opts)
  buf_map('n', 'g.', '<cmd>lua require("hasan.telescope.custom").lsp_document_symbols()<cr>', opts)

  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_map('n', '<F2>', '<cmd>lua require("lsp.util").rename_with_quickfix()<CR>', opts)
  buf_map('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', opts)
  if filetype ~= 'lua' and filetype ~= 'vim' then
    buf_map('n', '<F9>', '<cmd>lua vim.lsp.buf.formatting_sync()<CR><cmd>update<CR>', opts)
  end
  local code_action_keys = {'<C-q>', '<C-space>', '<leader>.'}
  for _, action_key in ipairs(code_action_keys) do
    buf_map('n', action_key, ':Telescope lsp_code_actions theme=get_cursor<CR>', opts)
    buf_map('v', action_key, ':Telescope lsp_range_code_actions theme=get_cursor<CR>', opts)
  end

  buf_map('n', '<leader>fs', '<cmd>lua vim.lsp.buf.formatting_sync()<CR><cmd>update<CR>', opts)
  buf_map('x', '<leader>fs', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR><cmd>update<CR>', opts)
  buf_map('n', '<leader>a+', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_map('n', '<leader>a-', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_map('n', '<leader>a?', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_map('n', '<leader>ah', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_map('n', '<leader>ad', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
  buf_map('n', '<leader>aD', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  if vim.fn.has "nvim-0.6.0" == 1  then
    buf_map('n', '[d', '<cmd>lua require("lsp.diagnosgic").jump_to_diagnostic("prev")<CR>', opts)
    buf_map('n', ']d', '<cmd>lua require("lsp.diagnosgic").jump_to_diagnostic("next")<CR>', opts)
    buf_map('n', '<leader>al', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  else
    buf_map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = "double"}})<CR>', opts)
    buf_map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = "double"}})<CR>', opts)
    buf_map('n', '<leader>al', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({show_header=false,border="double"})<CR>', opts)
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
  lsp_document_highlight(client)
  lsp_buffer_keymaps(client, bufnr)

  if client.name == 'tsserver' then
    -- lsp_tsserver_config(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end
  -- lunarvim
  -- vim.cmd 'command! -nargs=0 LspVirtualTextToggle lua require('lsp/virtual_text').toggle()'
  vim.cmd('command! -buffer Formate lua vim.lsp.buf.formatting()')
  vim.cmd('command! -buffer FormateSync lua vim.lsp.buf.formatting_sync()')
end

return M
