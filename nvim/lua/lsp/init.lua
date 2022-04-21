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
    local lsp_document_highlight = [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved,WinLeave,BufWinLeave,BufLeave <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]]
    vim.cmd(lsp_document_highlight)
  end
end

local function lsp_buffer_keymaps(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  keymap('n', 'gd', vim.lsp.buf.definition, opts)
  keymap('n', 'gD', vim.lsp.buf.declaration, opts)
  keymap('n', 'gy', vim.lsp.buf.type_definition, opts)
  keymap('n', 'gI', vim.lsp.buf.implementation, opts)
  keymap('n', 'gh', vim.lsp.buf.hover, opts)
  keymap('n', 'gH', vim.lsp.buf.signature_help, opts)
  keymap('n', 'gR', vim.lsp.buf.references, opts)
  keymap('n', 'gr', require('lsp.util').references_with_quickfix, opts)
  keymap('n', 'gpd', require('lsp.peek').PeekDefinition, opts)
  keymap('n', 'gpy', require('lsp.peek').PeekTypeDefinition, opts)
  keymap('n', 'gpI', require('lsp.peek').PeekImplementation, opts)
  keymap('n', '<F2>', require('lsp.util').lspRename, opts)
  keymap('n', '[d', '<cmd>lua require("lsp.diagnosgic").jump_to_diagnostic("prev")<CR>', opts)
  keymap('n', ']d', '<cmd>lua require("lsp.diagnosgic").jump_to_diagnostic("next")<CR>', opts)

  keymap('n', '<leader>.', '<cmd>Telescope lsp_document_symbols<cr>', opts)
  keymap('n', '<leader>fs', '<cmd>lua vim.lsp.buf.formatting_sync()<CR><cmd>update<CR>', opts)
  keymap('x', '<leader>fs', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR><cmd>update<CR>', opts)
  keymap('n', '<leader>aw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  keymap('n', '<leader>a+', vim.lsp.buf.add_workspace_folder, opts)
  keymap('n', '<leader>a-', vim.lsp.buf.remove_workspace_folder, opts)
  keymap('n', '<leader>ad', vim.lsp.diagnostic.set_loclist, opts)
  keymap('n', '<leader>aD', vim.diagnostic.setqflist, opts)
  keymap('n', '<leader>al', vim.diagnostic.open_float, opts)
  keymap('n', '<leader>ai', require('lsp.workspace').ts_organize_imports_sync, opts)
  keymap('n', '<leader>aq', require('lsp.util').showLspRenameChanges, opts)

  keymap('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', opts)
  if filetype ~= 'lua' and filetype ~= 'vim' then
    keymap('n', '<F9>', '<cmd>lua vim.lsp.buf.formatting_sync()<CR><cmd>update<CR>', opts)
  end
  local code_action_keys = { '<C-q>', '<C-space>', '<A-space>' }
  for _, action_key in ipairs(code_action_keys) do
    keymap('n', action_key, ':Telescope lsp_code_actions theme=get_cursor<CR>', opts)
    keymap('v', action_key, ':Telescope lsp_range_code_actions theme=get_cursor<CR>', opts)
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
  lsp_document_highlight(client)
  lsp_buffer_keymaps(client, bufnr)

  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end
  vim.cmd('command! -buffer Formate lua vim.lsp.buf.formatting()')
  vim.cmd('command! -buffer FormateSync lua vim.lsp.buf.formatting_sync()')
  -- if client.resolved_capabilities.document_formatting then
  --   vim.cmd[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
  --   autocmd BufWritePre *.js,*.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
  -- end
end

return M
