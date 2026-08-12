local M = {}

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
