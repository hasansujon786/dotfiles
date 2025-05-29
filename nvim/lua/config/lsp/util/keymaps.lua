local M = {}

---@type lsp.AttachCb
function M.lsp_buffer_keymaps(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function desc(str)
    return require('hasan.utils').merge({ desc = str }, opts)
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
  keymap('n', 'gR', '<cmd>Glance resume<CR>', desc('Lsp: Glance resume'))
  keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', desc('Lsp: Go to declaration'))

  keymap('n', 'gpd', '<cmd>lua require("config.lsp.util.peek").PeekDefinition()<CR>', desc('Peek definition'))
  keymap('n', 'gpI', '<cmd>lua require("config.lsp.util.peek").PeekImplementation()<CR>', desc('Peek implementation'))
  keymap('n', 'gpy', '<cmd>lua require("config.lsp.util.peek").PeekTypeDefinition()<CR>', desc('Peek type definition'))

  -- Action, Prompt, Search
  keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', desc('Lsp: Hover under cursor'))
  keymap('n', '<F2>', require('config.lsp.util.extras').lspRename, desc('Lsp: Rename under cursor'))
  for _, action_key in ipairs({ '<C-q>', '<C-space>', '<A-space>' }) do
    keymap({ 'n', 'x' }, action_key, vim.lsp.buf.code_action, desc('Lsp: Code action'))
  end

  -- Diagnostics
  keymap('n', '<leader>ad', vim.diagnostic.setloclist, desc('Lsp: Show local diagnostics'))
  keymap('n', '<leader>aD', vim.diagnostic.setqflist, desc('Lsp: Show global diagnostics'))
  keymap('n', '<leader>al', vim.diagnostic.open_float, desc('Lsp: Show line diagnostics'))

  keymap({ 'n', 'i' }, '<C-c><C-s>', vim.lsp.buf.signature_help, desc('Lsp: show signature help'))
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

-- -@type LspAttachCb
-- local function lsp_autocmds(client, bufnr)
--   if client.server_capabilities.documentHighlightProvider then
--     vim.cmd([[
--       augroup lsp_document_highlight
--         autocmd! * <buffer>
--         autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--         autocmd CursorMoved,WinLeave,BufWinLeave,BufLeave <buffer> lua vim.lsp.buf.clear_references()
--       augroup END
--       ]])
--     --   vim.cmd[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
--     --   autocmd BufWritePre *.js,*.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
--   end

--   -- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'InsertLeave' }, {
--   --   pattern = '*',
--   --   callback = function()
--   --     vim.notify('codelens active')
--   --     -- lsp.CodeLens
--   --     vim.lsp.codelens.refresh({ bufnr = bufnr })
--   --   end,
--   -- })
--   -- vim.api.nvim_create_autocmd('LspDetach', {
--   --   callback = function(opt)
--   --     vim.lsp.codelens.clear(opt.data.client_id, opt.buf)
--   --   end,
--   -- })
--   -- local bufopts = { noremap = true, silent = true, buffer = bufnr }
--   -- vim.keymap.set('n', '<leader>la', vim.lsp.codelens.run, bufopts)
-- end

return M
