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

---@type ServerConfig
return {
  setup = function(_, bufnr)
    keymap('n', '<leader>ai', M.ts_organize_imports_sync, { buffer = bufnr, desc = 'Lsp: organize imports' })
  end,
  opts = {
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
