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

local inlayHints = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = true,
}

local function filterReactDTS(value)
  return string.match(value.targetUri, 'index.d.ts') == nil
  -- return string.match(value.uri, '%.d.ts') == nil
end

---@type ServerConfig
return {
  lsp_attach = function(_, bufnr)
    keymap('n', '<leader>ai', M.ts_organize_imports_sync, { buffer = bufnr, desc = 'Lsp: organize imports' })
  end,
  opts = {
    handlers = {
      ['textDocument/definition'] = function(err, results, method, ...)
        if vim.islist(results) and #results > 1 then
          local filtered_result = vim.tbl_filter(filterReactDTS, results)
          return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
        end

        vim.lsp.handlers['textDocument/definition'](err, results, method, ...)
      end,
    },
    -- See: https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
    settings = {
      -- implicitProjectConfiguration = {
      --   checkJs = true,
      --   target = 'ES2022',
      -- },
      javascript = {
        inlayHints = inlayHints,
      },
      typescript = {
        inlayHints = inlayHints,
      },
    },
  },
}
