local utils = {}

--------------------------------------------------
-------- Organize Imports ------------------------
--------------------------------------------------
local METHOD = 'workspace/executeCommand'
local function make_organize_imports_params(bufnr)
  return { command = 'typescript.organizeImports', arguments = { vim.api.nvim_buf_get_name(bufnr) } }
end
function utils.ts_organize_imports_async(bufnr, post)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.lsp.buf_request(bufnr, METHOD, make_organize_imports_params(bufnr), function(err)
    if not err and post then
      post()
    end
  end)
end
function utils.ts_organize_imports_sync(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.lsp.buf_request_sync(bufnr, METHOD, make_organize_imports_params(bufnr), 500)
end

-- https://github.com/yioneko/nvim-vtsls
local inlayHints = {
  parameterNames = { enabled = 'literals' },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}
return {
  on_attach = function(client, bufnr)
    keymap('n', '<leader>ai', utils.ts_organize_imports_sync, { buffer = bufnr, desc = 'Lsp: organize imports' })
  end,
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      inlayHints = inlayHints,
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = { completeFunctionCalls = true },
    },
    javascript = { inlayHints = inlayHints },
  },
}
