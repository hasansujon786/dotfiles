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

  keymap('n', 'gd', '<cmd>Glance definitions<CR>', desc('Lsp: go to definition'))
  keymap('n', 'gr', '<cmd>Glance references<CR>', desc('Lsp: go to references'))
  keymap('n', 'gm', '<cmd>Glance implementations<CR>', desc('Lsp: type implementation'))
  keymap('n', 'gy', '<cmd>Glance type_definitions<CR>', desc('Lsp: type definition'))
  -- keymap('n', 'gd', vim.lsp.buf.definition, desc('Lsp: go to definition'))
  -- keymap('n', 'gr', require('config.lsp.util.extras').references_and_focus_cur_ref, desc('Lsp: go to references'))
  -- keymap('n', 'gm', vim.lsp.buf.implementation, desc('Lsp: type implementation'))
  -- keymap('n', 'gy', vim.lsp.buf.type_definition, desc('Lsp: type definition'))
  keymap('n', 'gD', vim.lsp.buf.declaration, desc('Lsp: go to declaration'))
  keymap('n', 'gR', vim.lsp.buf.references, desc('Lsp: go to references'))
  keymap('n', 'gp', require('config.lsp.util.peek').PeekDefinition, desc('Lsp: peek definition'))
  keymap('n', 'gP', require('config.lsp.util.peek').PeekTypeDefinition, desc('Lsp: peek type definition'))
  keymap('n', 'gM', require('config.lsp.util.peek').PeekImplementation, desc('Lsp: peek implementation'))
  keymap('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', desc('which_key_ignore'))

  -- Action, Prompt, Search
  keymap('n', 'K', vim.lsp.buf.hover, desc('Lsp: hover under cursor'))
  keymap('n', '<F2>', require('config.lsp.util.extras').lspRename, desc('Lsp: rename under cursor'))
  if client.server_capabilities.documentSymbolProvider then
    keymap('n', 'go', require('hasan.telescope.lsp').prettyDocumentSymbols, desc('Lsp: document symbols'))
    keymap('n', 'g.', require('hasan.telescope.lsp').prettyDocumentSymbols, desc('Lsp: document symbols'))
  end
  for _, action_key in ipairs({ '<C-q>', '<C-space>', '<A-space>' }) do
    keymap({ 'n', 'x' }, action_key, vim.lsp.buf.code_action, desc('Lsp: code action'))
  end

  -- Diagnostics
  keymap('n', '<leader>ad', vim.diagnostic.setqflist, desc('Lsp: show global diagnostics'))
  keymap('n', '<leader>aD', vim.diagnostic.setloclist, desc('Lsp: show local diagnostics'))
  keymap('n', '<leader>al', vim.diagnostic.open_float, desc('Lsp: show line diagnostics'))
  keymap('n', ']d', require('config.lsp.util.diagnosgic').diagnostic_goto(true), desc('Lsp: Next diagnosgic'))
  keymap('n', '[d', require('config.lsp.util.diagnosgic').diagnostic_goto(false), desc('Lsp: Prev diagnosgic'))
  keymap('n', ']E', require('config.lsp.util.diagnosgic').diagnostic_goto(true, 'ERROR'), desc('Lsp: Next Error'))
  keymap('n', '[E', require('config.lsp.util.diagnosgic').diagnostic_goto(false, 'ERROR'), desc('Lsp: Prev Error'))
  keymap('n', ']w', require('config.lsp.util.diagnosgic').diagnostic_goto(true, 'WARN'), desc('Lsp: Next Warning'))
  keymap('n', '[w', require('config.lsp.util.diagnosgic').diagnostic_goto(false, 'WARN'), desc('Lsp: Prev Warning'))

  -- Format
  keymap({ 'n', 'x' }, '<leader>fs', '<cmd>lua vim.lsp.buf.format()<CR><cmd>w<CR>', desc('Lsp: format and save'))
  command('Format', function(_)
    vim.lsp.buf.format({ async = true })
  end)
  command('FormatSync', function()
    vim.lsp.buf.format({ async = false })
  end)

  keymap('n', '<leader>ar', '<cmd>Telescope lsp_references<CR>', desc('Lsp: Preview references'))
  keymap('n', '<leader>ak', vim.lsp.buf.signature_help, desc('Lsp: show signature help'))
  keymap('n', '<leader>aq', require('config.lsp.util.extras').showLspRenameChanges, desc('Lsp: show lsp rename'))

  keymap('n', '<leader>a+', vim.lsp.buf.add_workspace_folder, desc('Lsp: add workspace folder'))
  keymap('n', '<leader>a-', vim.lsp.buf.remove_workspace_folder, desc('Lsp: remove workspace folder'))
  keymap('n', '<leader>aw', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, desc('Lsp: list workspace folders'))
end

return M
