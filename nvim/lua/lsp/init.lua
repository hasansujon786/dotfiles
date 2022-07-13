local M = {}
local hasNvim8 = vim.fn.has('nvim-0.8') == 1
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
    if hasNvim8 then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    else
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
  end
end

function M.lsp_autocmds(client, bufnr)
  if
    hasNvim8 and client.server_capabilities.documentHighlightProvider
    or client.resolved_capabilities.document_highlight
  then
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

function M.lsp_buffer_keymaps(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function withDesc(desc)
    return require('hasan.utils').merge({
      desc = desc,
    }, opts or {})
  end

  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  keymap('n', 'K', vim.lsp.buf.hover, withDesc('Lsp: hover under cursor'))
  keymap('n', 'g.', '<cmd>Telescope lsp_document_symbols<cr>', withDesc('Lsp: document symbols'))
  keymap('n', 'gd', vim.lsp.buf.definition, withDesc('Lsp: go to definition'))
  keymap('n', 'gD', vim.lsp.buf.declaration, withDesc('Lsp: go to declaration'))
  keymap('n', 'gr', require('lsp.util').references_with_quickfix, withDesc('Lsp: go to references'))
  keymap('n', 'gR', vim.lsp.buf.references, withDesc('Lsp: go to references'))
  keymap('n', 'gy', vim.lsp.buf.type_definition, withDesc('Lsp: type definition'))
  keymap('n', 'gI', vim.lsp.buf.implementation, withDesc('Lsp: type implementation'))
  keymap('n', 'gp', require('lsp.peek').PeekDefinition, withDesc('Lsp: peek definition'))
  keymap('n', 'gP', require('lsp.peek').PeekTypeDefinition, withDesc('Lsp: peek type definition'))
  -- keymap('n', 'gpI', require('lsp.peek').PeekImplementation, opts)
  keymap('n', '<F2>', require('lsp.util').lspRename, withDesc('Lsp: rename under cursor'))
  keymap({ 'i', 'n' }, '<C-k>h', function()
    if require('cmp').visible() then
      require('cmp').close()
    end
    vim.lsp.buf.signature_help()
  end, withDesc('Lsp: show signature help'))
  keymap('n', '[d', '<cmd>lua require("lsp.diagnosgic").jump_to_diagnostic("prev")<CR>', withDesc('Lsp: jump to previous diagnosgic'))
  keymap('n', ']d', '<cmd>lua require("lsp.diagnosgic").jump_to_diagnostic("next")<CR>', withDesc('Lsp: jump to next diagnosgic'))

  keymap('n', '<leader>fs', '<cmd>lua vim.lsp.buf.formatting_sync()<CR><cmd>update<CR>', withDesc('Lsp: format and save'))
  keymap('x', '<leader>fs', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR><cmd>update<CR>', withDesc('Lsp: format and save document'))
  keymap('n', '<leader>aw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', withDesc('Lsp: list workspace folders'))
  keymap('n', '<leader>a+', vim.lsp.buf.add_workspace_folder, withDesc('Lsp: add workspace folder'))
  keymap('n', '<leader>a-', vim.lsp.buf.remove_workspace_folder, withDesc('Lsp: remove workspace folder'))
  keymap('n', '<leader>ad', vim.lsp.diagnostic.set_loclist, withDesc('Lsp: show local diagnostics'))
  keymap('n', '<leader>aD', vim.diagnostic.setqflist, withDesc('Lsp: show global diagnostics'))
  keymap('n', '<leader>al', vim.diagnostic.open_float, withDesc('Lsp: show current diagnostics'))
  keymap('n', '<leader>ai', require('lsp.workspace').ts_organize_imports_sync, withDesc('Lsp: organize ts imports'))
  keymap('n', '<leader>aq', require('lsp.util').showLspRenameChanges, withDesc('Lsp: show lsp rename'))

  keymap('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', opts)
  local code_action_keys = { '<C-q>', '<C-space>', '<A-space>' }
  for _, action_key in ipairs(code_action_keys) do
    keymap('n', action_key, require('lsp.util').code_action, withDesc('Lsp: code action'))
    keymap('v', action_key, require('lsp.util').range_code_action, withDesc('Lsp: code action'))
  end

  vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
  vim.api.nvim_create_user_command('FormatSync', vim.lsp.buf.formatting_sync, {})
end

return M
