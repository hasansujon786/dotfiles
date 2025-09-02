local M = {}

---@param cmds string[]
---@param after function
local code_action = function(cmds, after)
  local win = vim.api.nvim_get_current_win()
  local offset_encoding = 'utf-16'
  local params = vim.lsp.util.make_range_params(win, offset_encoding)
  params.context = { only = cmds }

  ---@param err? lsp.ResponseError
  ---@param res? (lsp.Command|lsp.CodeAction)[]
  ---@param ctx lsp.HandlerContext
  local on_result = function(err, res, ctx)
    if err then
      return
    end
    if not res then
      return
    end

    for _, r in pairs(res) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(ctx.client_id) or {}).offset_encoding
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
        -- else
        -- fallback: if it's a command, execute it
        -- if r.command then
        --   client:exec_cmd(r.command, ctx)
        -- end
      end
    end

    if after then
      after()
    end
  end
  vim.lsp.buf_request(0, 'textDocument/codeAction', params, on_result)
end

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
  -- keymap('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', desc('which_key_ignore'))
  keymap('n', 'gd', '<cmd>Glance definitions<CR>', desc('Lsp: Go to definition'))
  keymap('n', 'gr', '<cmd>Glance references<CR>', desc('Lsp: Go to references'))
  keymap('n', 'gI', '<cmd>Glance implementations<CR>', desc('Lsp: Type implementation'))
  keymap('n', 'gy', '<cmd>Glance type_definitions<CR>', desc('Lsp: Type definition'))
  keymap('n', 'gR', '<cmd>Glance resume<CR>', desc('Lsp: Glance resume'))
  keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', desc('Lsp: Go to declaration'))

  keymap('n', '<leader>a.', run_code_action({ 'source.fixAll' }), desc('Lsp: Fix all'))
  keymap('n', '<leader>ai', function()
    code_action({ 'source.organizeImports' }, vim.cmd.write)
  end, desc('Lsp: Organize imports'))

  keymap('n', 'gpd', '<cmd>lua require("config.lsp.util.peek").PeekDefinition()<CR>', desc('Peek definition'))
  keymap('n', 'gpI', '<cmd>lua require("config.lsp.util.peek").PeekImplementation()<CR>', desc('Peek implementation'))
  keymap('n', 'gpy', '<cmd>lua require("config.lsp.util.peek").PeekTypeDefinition()<CR>', desc('Peek type definition'))

  -- Action, Prompt, Search
  keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', desc('Lsp: Hover under cursor'))
  keymap('n', '<F2>', '<cmd>lua require("config.lsp.util.extras").lsp_rename()<CR>', desc('Lsp: Rename under cursor'))
  for _, action_key in ipairs({ '<C-q>', '<C-space>', '<A-space>' }) do
    keymap({ 'n', 'x' }, action_key, '<cmd>lua vim.lsp.buf.code_action()<CR>', desc('Lsp: Code action'))
  end

  -- Diagnostics
  keymap('n', '<leader>ad', '<cmd>lua vim.diagnostic.setloclist()<CR>', desc('Lsp: Show local diagnostics'))
  keymap('n', '<leader>aD', '<cmd>lua vim.diagnostic.setqflist()<CR>', desc('Lsp: Show global diagnostics'))
  keymap('n', '<leader>al', '<cmd>lua vim.diagnostic.open_float()<CR>', desc('Lsp: Show line diagnostics'))

  keymap({ 'n', 'i' }, '<C-c><C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', desc('Lsp: show signature help'))
  -- keymap('n', '<leader>th', function()
  --   local is_enabled = vim.lsp.inlay_hint.is_enabled({})
  --   vim.lsp.inlay_hint.enable(not is_enabled)
  -- end, desc('Lsp: toggle inlay_hint'))

  keymap('n', '<leader>a+', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', desc('Lsp: Add workspace folder'))
  keymap('n', '<leader>a-', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', desc('Lsp: Remove workspace folder'))
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
