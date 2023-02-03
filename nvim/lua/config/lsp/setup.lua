local M = {}
-- local hasNvim8 = vim.fn.has('nvim-0.8') == 1
local borderOpts = { border = require('core.state').ui.border.style }

require('config.lsp.diagnosgic').setup()
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, borderOpts)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, borderOpts)

local use_builtin_lsp_formatter = { 'dartls', 'astro' }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
  M.lsp_autocmds(client, bufnr)
  M.lsp_buffer_keymaps(client, bufnr)

  if client.name == 'tailwindcss' and state.treesitter.auto_conceal_html_class then
    require('hasan.utils.ts_query').setup_tailwindcss(bufnr)
  end
  if not vim.tbl_contains(use_builtin_lsp_formatter, client.name) then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

function M.lsp_autocmds(client, bufnr)
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

function M.lsp_buffer_keymaps(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function desc(str)
    return require('hasan.utils').merge({ desc = str }, opts or {})
  end

  -- local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  -- local function buf_set_option(...)
  --   vim.api.nvim_buf_set_option(bufnr, ...)
  -- end
  --Enable completion triggered by <c-x><c-o>
  -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  keymap('n', 'gd', vim.lsp.buf.definition, desc('Lsp: go to definition'))
  keymap('n', 'gD', vim.lsp.buf.declaration, desc('Lsp: go to declaration'))
  keymap('n', 'gr', require('config.lsp.util').references_with_quickfix, desc('Lsp: go to references'))
  keymap('n', 'gR', vim.lsp.buf.references, desc('Lsp: go to references'))
  keymap('n', 'gp', require('config.lsp.peek').PeekDefinition, desc('Lsp: peek definition'))
  keymap('n', 'gP', require('config.lsp.peek').PeekTypeDefinition, desc('Lsp: peek type definition'))
  keymap('n', 'gm', vim.lsp.buf.implementation, desc('Lsp: type implementation'))
  keymap('n', 'gy', vim.lsp.buf.type_definition, desc('Lsp: type definition'))

  keymap('n', 'K', vim.lsp.buf.hover, desc('Lsp: hover under cursor'))
  keymap('n', 'g/', '<cmd>Telescope lsp_document_symbols<cr>', desc('Lsp: document symbols'))
  keymap('n', 'go', '<cmd>Telescope lsp_document_symbols<cr>', desc('Lsp: document symbols'))
  -- keymap('n', 'gpI', require('config.lsp.peek').PeekImplementation, opts)
  keymap('n', '<F2>', require('config.lsp.util').lspRename, desc('Lsp: rename under cursor'))
  keymap({ 'i', 'n' }, '<C-k>h', function()
    if require('cmp').visible() then
      require('cmp').close()
    end
    vim.lsp.buf.signature_help()
  end, desc('Lsp: show signature help'))
  keymap('n', '[d', '<cmd>lua require("config.lsp.diagnosgic").jump_to_diagnostic("prev")<CR>', desc('Lsp: jump to previous diagnosgic'))
  keymap('n', ']d', '<cmd>lua require("config.lsp.diagnosgic").jump_to_diagnostic("next")<CR>', desc('Lsp: jump to next diagnosgic'))

  keymap('n', '<leader>fs', '<cmd>lua require("hasan.utils.file").smart_save_buffer()<cr>', desc('Lsp: format and save'))
  keymap('x', '<leader>fs', 'gq<cmd>silent noa write<cr>', desc('Lsp: format current selection'))
  keymap('n', '<leader>aw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', desc('Lsp: list workspace folders'))
  keymap('n', '<leader>a+', vim.lsp.buf.add_workspace_folder, desc('Lsp: add workspace folder'))
  keymap('n', '<leader>a-', vim.lsp.buf.remove_workspace_folder, desc('Lsp: remove workspace folder'))
  keymap('n', '<leader>ad', vim.diagnostic.setloclist, desc('Lsp: show local diagnostics'))
  keymap('n', '<leader>aD', vim.diagnostic.setqflist, desc('Lsp: show global diagnostics'))
  keymap('n', '<leader>al', vim.diagnostic.open_float, desc('Lsp: show current diagnostics'))
  keymap('n', '<leader>ai', require('config.lsp.workspace').ts_organize_imports_sync, desc('Lsp: organize ts imports'))
  keymap('n', '<leader>aq', require('config.lsp.util').showLspRenameChanges, desc('Lsp: show lsp rename'))

  keymap('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', opts)
  local code_action_keys = { '<C-q>', '<C-space>', '<A-space>' }
  for _, action_key in ipairs(code_action_keys) do
    keymap({ 'n', 'x' }, action_key, require('config.lsp.util').code_action, desc('Lsp: code action'))
  end

  vim.api.nvim_create_user_command('Format', function()
    vim.lsp.buf.format({ async = true })
  end, {})
  vim.api.nvim_create_user_command('FormatSync', function()
    vim.lsp.buf.format({ async = false })
  end, {})
end

return M
