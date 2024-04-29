local lsp = vim.lsp
local api = vim.api
local M = {}

--------------------------------------------------
-------- Organize Imports ------------------------
--------------------------------------------------
local METHOD = 'workspace/executeCommand'
local function make_organize_imports_params(bufnr)
  return { command = '_typescript.organizeImports', arguments = { api.nvim_buf_get_name(bufnr) } }
end
function M.ts_organize_imports_async(bufnr, post)
  bufnr = bufnr or api.nvim_get_current_buf()
  lsp.buf_request(bufnr, METHOD, make_organize_imports_params(bufnr), function(err)
    if not err and post then
      post()
    end
  end)
end
function M.ts_organize_imports_sync(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  lsp.buf_request_sync(bufnr, METHOD, make_organize_imports_params(bufnr), 500)
end

return {
  setup = function(client, bufnr)
    keymap('n', '<leader>ai', M.ts_organize_imports_sync, { buffer = bufnr, desc = 'Lsp: organize imports' })

    local ok, twoslashqueries = pcall(require, 'twoslash-queries')
    if ok then
      twoslashqueries.attach(client, bufnr)
    end
  end,
}
