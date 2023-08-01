local M = {}
-- local hasNvim8 = vim.fn.has('nvim-0.8') == 1

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.on_attach(client, bufnr)
  M.lsp_autocmds(client)
  M.lsp_buffer_keymaps(client, bufnr)
  M.setup_format(client)
  M.server_specific_setup(client, bufnr)
end

function M.update_capabilities()
  local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_ok then
    return cmp_nvim_lsp.default_capabilities()
  end
  vim.notify('cmp_nvim_lsp not loaded with lsp-config', vim.log.levels.WARN)
end

function M.setup_format(client)
  if not vim.tbl_contains(require('config.lsp.lsp-config').use_builtin_lsp_formatter, client.name) then
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

function M.server_specific_setup(client, bufnr)
  if client.name == 'tailwindcss' then
    require('config.lsp.server.tailwindcss').setup(bufnr)
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

  keymap('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', 'gd', vim.lsp.buf.definition, desc('Lsp: go to definition'))
  keymap('n', 'gD', vim.lsp.buf.declaration, desc('Lsp: go to declaration'))
  keymap('n', 'gr', require('config.lsp.util').references_and_focus_cur_ref, desc('Lsp: go to references'))
  keymap('n', 'gR', vim.lsp.buf.references, desc('Lsp: go to references'))
  keymap('n', 'gp', require('config.lsp.peek').PeekDefinition, desc('Lsp: peek definition'))
  keymap('n', 'gP', require('config.lsp.peek').PeekTypeDefinition, desc('Lsp: peek type definition'))
  keymap('n', 'gm', vim.lsp.buf.implementation, desc('Lsp: type implementation'))
  keymap('n', 'gy', vim.lsp.buf.type_definition, desc('Lsp: type definition'))
  keymap('n', 'K', vim.lsp.buf.hover, desc('Lsp: hover under cursor'))
  -- keymap('n', 'gpI', require('config.lsp.peek').PeekImplementation, opts)

  -- Action, Prompt, Search
  keymap('n', 'g/', '<cmd>Telescope lsp_document_symbols<cr>', desc('Lsp: document symbols'))
  keymap('n', 'go', '<cmd>Telescope lsp_document_symbols<cr>', desc('Lsp: document symbols'))
  keymap('n', 'g.', '<cmd>Telescope lsp_document_symbols<cr>', desc('Lsp: document symbols'))
  keymap('n', '<F2>', require('config.lsp.util').lspRename, desc('Lsp: rename under cursor'))
  keymap('n', '<leader>aq', require('config.lsp.util').showLspRenameChanges, desc('Lsp: show lsp rename'))
  for _, action_key in ipairs({ '<C-q>', '<C-space>', '<A-space>' }) do
    keymap({ 'n', 'x' }, action_key, require('config.lsp.util').code_action, desc('Lsp: code action'))
  end

  -- Insert mode bind
  keymap({ 'i', 'n' }, '<C-k>h', function()
    if require('cmp').visible() then
      require('cmp').close()
    end
    vim.lsp.buf.signature_help()
  end, desc('Lsp: show signature help'))

  -- Diagnostics
  keymap('n', '<leader>ad', vim.diagnostic.setloclist, desc('Lsp: show local diagnostics'))
  keymap('n', '<leader>aD', vim.diagnostic.setqflist, desc('Lsp: show global diagnostics'))
  keymap('n', '<leader>al', vim.diagnostic.open_float, desc('Lsp: show current diagnostics'))
  keymap('n', '[d', function()
    require('config.lsp.diagnosgic').jump_to_diagnostic('prev')
  end, desc('Lsp: jump to previous diagnosgic'))
  keymap('n', ']d', function()
    require('config.lsp.diagnosgic').jump_to_diagnostic('next')
  end, desc('Lsp: jump to next diagnosgic'))

  -- Format
  keymap('n', '<leader>fs', function()
    require('hasan.utils.file').smart_save_buffer()
  end, desc('Lsp: format and save'))
  keymap('x', '<leader>fs', 'gq<cmd>silent noa write<cr>', desc('Lsp: format current selection'))
  vim.api.nvim_create_user_command('Format', function()
    vim.lsp.buf.format({ async = true })
  end, {})
  vim.api.nvim_create_user_command('FormatSync', function()
    vim.lsp.buf.format({ async = false })
  end, {})

  keymap('n', '<leader>a+', vim.lsp.buf.add_workspace_folder, desc('Lsp: add workspace folder'))
  keymap('n', '<leader>a-', vim.lsp.buf.remove_workspace_folder, desc('Lsp: remove workspace folder'))
  keymap('n', '<leader>aw', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, desc('Lsp: list workspace folders'))

  -- Server specific
  if client.name == 'tsserver' then
    keymap('n', '<leader>ai', function()
      require('config.lsp.server.tsserver').ts_organize_imports_sync()
    end, desc('Lsp: organize ts imports'))
  end
end

return M
