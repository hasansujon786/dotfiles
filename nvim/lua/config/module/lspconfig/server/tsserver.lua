local lsp = vim.lsp
local api = vim.api

local METHOD = 'workspace/executeCommand'

local M = {}
local function make_params(bufnr)
  return {
    command = '_typescript.organizeImports',
    arguments = { api.nvim_buf_get_name(bufnr) },
  }
end

function M.ts_organize_imports_async(bufnr, post)
  bufnr = bufnr or api.nvim_get_current_buf()

  lsp.buf_request(bufnr, METHOD, make_params(bufnr), function(err)
    if not err and post then
      post()
    end
  end)
end

function M.ts_organize_imports_sync(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()

  lsp.buf_request_sync(bufnr, METHOD, make_params(bufnr), 500)
end

return M
