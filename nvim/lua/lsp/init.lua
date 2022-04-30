local M = {}
local borderOpts = { border = require('state').ui.border.style }

require('lsp.diagnosgic').setup()
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, borderOpts)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, borderOpts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
  M.lsp_autocmds(client, bufnr)
  M.lsp_buffer_keymaps(client, bufnr)

  if client.name ~= 'dartls' then
    -- client.server_capabilities.documentFormattingProvider = false
    -- client.server_capabilities.documentRangeFormattingProvider = false
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end
end

function M.lsp_autocmds(client, bufnr)
  if client.resolved_capabilities.document_highlight then
    local augroup = require('hasan.utils').augroup
    local opts = { buffer = bufnr }

    augroup('lsp_autocmds')(function(autocmd)
      autocmd('CursorHold', vim.lsp.buf.document_highlight, opts)
      autocmd({ 'CursorMoved', 'WinLeave', 'BufWinLeave', 'BufLeave' }, vim.lsp.buf.clear_references, opts)

      --   vim.cmd[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
      --   autocmd BufWritePre *.js,*.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
    end)
  end
end

function M.lsp_buffer_keymaps(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  keymap('n', 'K', vim.lsp.buf.hover, opts)
  keymap('n', 'gd', vim.lsp.buf.definition, opts)
  keymap('n', 'gD', vim.lsp.buf.declaration, opts)
  keymap('n', 'gr', require('lsp.util').references_with_quickfix, opts)
  keymap('n', 'gR', vim.lsp.buf.references, opts)
  keymap('n', 'gy', vim.lsp.buf.type_definition, opts)
  keymap('n', 'gI', vim.lsp.buf.implementation, opts)
  keymap('n', 'gp', require('lsp.peek').PeekDefinition, opts)
  keymap('n', 'gP', require('lsp.peek').PeekTypeDefinition, opts)
  -- keymap('n', 'gpI', require('lsp.peek').PeekImplementation, opts)
  keymap('n', '<F2>', require('lsp.util').lspRename, opts)
  keymap('n', '<F1>', vim.lsp.buf.signature_help, opts)
  keymap('i', '<F1>', function()
    if require('cmp').visible() then
      require('cmp').close()
    end
    vim.lsp.buf.signature_help()
  end, opts)
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
    keymap('n', action_key, require('lsp.util').code_action, opts)
    keymap('v', action_key, require('lsp.util').range_code_action, opts)
  end

  vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
  vim.api.nvim_create_user_command('FormatSync', vim.lsp.buf.formatting_sync, {})
end

return M
