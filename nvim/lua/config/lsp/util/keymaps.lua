local M = {}

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
  keymap('n', 'gr', require('config.lsp.util.extras').references_and_focus_cur_ref, desc('Lsp: go to references'))
  keymap('n', 'gR', vim.lsp.buf.references, desc('Lsp: go to references'))
  keymap('n', 'gp', require('config.lsp.util.peek').PeekDefinition, desc('Lsp: peek definition'))
  keymap('n', 'gP', require('config.lsp.util.peek').PeekTypeDefinition, desc('Lsp: peek type definition'))
  keymap('n', 'gm', vim.lsp.buf.implementation, desc('Lsp: type implementation'))
  keymap('n', 'gy', vim.lsp.buf.type_definition, desc('Lsp: type definition'))
  keymap('n', 'K', vim.lsp.buf.hover, desc('Lsp: hover under cursor'))
  -- keymap('n', 'gpI', require('config.lsp.util.peek').PeekImplementation, opts)

  -- Action, Prompt, Search
  keymap('n', 'g/', '<cmd>Telescope lsp_document_symbols<cr>', desc('Lsp: document symbols'))
  keymap('n', 'go', '<cmd>Telescope lsp_document_symbols<cr>', desc('Lsp: document symbols'))
  keymap('n', 'g.', '<cmd>Telescope lsp_document_symbols<cr>', desc('Lsp: document symbols'))
  keymap('n', '<F2>', require('config.lsp.util.extras').lspRename, desc('Lsp: rename under cursor'))
  keymap('n', '<leader>aq', require('config.lsp.util.extras').showLspRenameChanges, desc('Lsp: show lsp rename'))
  for _, action_key in ipairs({ '<C-q>', '<C-space>', '<A-space>' }) do
    keymap({ 'n', 'x' }, action_key, vim.lsp.buf.code_action, desc('Lsp: code action'))
  end

  -- Diagnostics
  keymap('n', '<leader>ad', vim.diagnostic.setloclist, desc('Lsp: show local diagnostics'))
  keymap('n', '<leader>aD', vim.diagnostic.setqflist, desc('Lsp: show global diagnostics'))
  keymap('n', '<leader>al', vim.diagnostic.open_float, desc('Lsp: show current diagnostics'))
  keymap('n', '[d', function() require('config.lsp.util.diagnosgic').jump_to_diagnostic('prev') end, desc('Lsp: jump to previous diagnosgic'))
  keymap('n', ']d', function() require('config.lsp.util.diagnosgic').jump_to_diagnostic('next') end, desc('Lsp: jump to next diagnosgic'))

  -- Format
  keymap('n', '<leader>fs', function() require('hasan.utils.file').smart_save_buffer() end, desc('Lsp: format and save'))
  keymap('x', '<leader>fs', 'gq<cmd>silent noa write<cr>', desc('Lsp: format current selection'))

  command('Format', function(_) vim.lsp.buf.format({ async = true }) end)
  command('FormatSync', function() vim.lsp.buf.format({ async = false }) end)

  keymap('n', '<leader>a+', vim.lsp.buf.add_workspace_folder, desc('Lsp: add workspace folder'))
  keymap('n', '<leader>a-', vim.lsp.buf.remove_workspace_folder, desc('Lsp: remove workspace folder'))
  keymap('n', '<leader>aw', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc('Lsp: list workspace folders'))
  keymap('n', '<leader>ak', vim.lsp.buf.signature_help, desc('Lsp: show signature help'))
end

return M
