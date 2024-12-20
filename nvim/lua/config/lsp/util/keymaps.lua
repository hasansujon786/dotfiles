local M = {}

---@type LspAttachCb
function M.lsp_buffer_keymaps(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function desc(str)
    return require('hasan.utils').merge({ desc = str }, opts or {})
  end
  --Enable completion triggered by <c-x><c-o>
  -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- keymap('n', 'gd', vim.lsp.buf.definition, desc('Lsp: go to definition'))
  -- keymap('n', 'gr', vim.lsp.buf.references, desc('Lsp: go to references'))
  -- keymap('n', 'gm', vim.lsp.buf.implementation, desc('Lsp: type implementation'))
  -- keymap('n', 'gy', vim.lsp.buf.type_definition, desc('Lsp: type definition'))
  keymap('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', desc('which_key_ignore'))
  keymap('n', 'gd', '<cmd>Glance definitions<CR>', desc('Lsp: Go to definition'))
  keymap('n', 'gr', '<cmd>Glance references<CR>', desc('Lsp: Go to references'))
  keymap('n', 'gI', '<cmd>Glance implementations<CR>', desc('Lsp: Type implementation'))
  keymap('n', 'gy', '<cmd>Glance type_definitions<CR>', desc('Lsp: Type definition'))
  keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', desc('Lsp: Go to declaration'))

  keymap('n', 'gpp', '<cmd>Glance resume<CR>', desc('Lsp: Glance resume'))
  keymap('n', 'gpd', require('config.lsp.util.peek').PeekDefinition, desc('Lsp: Peek definition'))
  keymap('n', 'gpI', require('config.lsp.util.peek').PeekImplementation, desc('Lsp: Peek implementation'))
  keymap('n', 'gpy', require('config.lsp.util.peek').PeekTypeDefinition, desc('Lsp: Peek type definition'))

  -- Action, Prompt, Search
  keymap('n', 'K', vim.lsp.buf.hover, desc('Lsp: Hover under cursor'))
  keymap('n', '<F2>', require('config.lsp.util.extras').lspRename, desc('Lsp: Rename under cursor'))
  for _, action_key in ipairs({ '<C-q>', '<C-space>', '<A-space>' }) do
    keymap({ 'n', 'x' }, action_key, vim.lsp.buf.code_action, desc('Lsp: Code action'))
  end

  -- Diagnostics
  keymap('n', '<leader>ad', vim.diagnostic.setloclist, desc('Lsp: Show local diagnostics'))
  keymap('n', '<leader>aD', vim.diagnostic.setqflist, desc('Lsp: Show global diagnostics'))
  keymap('n', '<leader>al', vim.diagnostic.open_float, desc('Lsp: Show line diagnostics'))
  keymap('n', ']d', require('config.lsp.util.diagnosgic').diagnostic_goto(true), desc('Lsp: Next diagnosgic'))
  keymap('n', '[d', require('config.lsp.util.diagnosgic').diagnostic_goto(false), desc('Lsp: Prev diagnosgic'))
  keymap('n', ']E', require('config.lsp.util.diagnosgic').diagnostic_goto(true, 'ERROR'), desc('Lsp: Next Error'))
  keymap('n', '[E', require('config.lsp.util.diagnosgic').diagnostic_goto(false, 'ERROR'), desc('Lsp: Prev Error'))
  keymap('n', ']w', require('config.lsp.util.diagnosgic').diagnostic_goto(true, 'WARN'), desc('Lsp: Next Warning'))
  keymap('n', '[w', require('config.lsp.util.diagnosgic').diagnostic_goto(false, 'WARN'), desc('Lsp: Prev Warning'))

  keymap('n', '<leader>ak', vim.lsp.buf.signature_help, desc('Lsp: show signature help'))
  keymap('n', '<leader>aq', require('config.lsp.util.extras').showLspRenameChanges, desc('Lsp: Show lsp rename'))
  -- keymap('n', '<leader>th', function()
  --   local is_enabled = vim.lsp.inlay_hint.is_enabled({})
  --   vim.lsp.inlay_hint.enable(not is_enabled)
  -- end, desc('Lsp: toggle inlay_hint'))

  keymap('n', '<leader>a+', vim.lsp.buf.add_workspace_folder, desc('Lsp: Add workspace folder'))
  keymap('n', '<leader>a-', vim.lsp.buf.remove_workspace_folder, desc('Lsp: Remove workspace folder'))
  keymap('n', '<leader>aw', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, desc('Lsp: list workspace folders'))
end

return M
