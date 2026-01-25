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
  parameterTypes = { enabled = true, suppressWhenArgumentMatchesName = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

local vue_language_server_path = mason_path .. '/vue-language-server/node_modules/@vue/language-server'
local vueGlobalPlugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
  enableForWorkspaceTypeScriptVersions = true,
}

---@module "vim.lsp.client"
---@class vim.lsp.ClientConfig
return {
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  on_attach = function(client, bufnr)
    if vim.bo.filetype == 'vue' then
      client.server_capabilities.semanticTokensProvider.full = false
    else
      client.server_capabilities.semanticTokensProvider.full = true
    end

    keymap('n', '<leader>ai', utils.ts_organize_imports_sync, { buffer = bufnr, desc = 'Lsp: organize imports' })
  end,
  settings = {
    complete_function_calls = true,
    vtsls = {
      tsserver = { globalPlugins = { vueGlobalPlugin } },
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
    vue = { inlayHints = inlayHints },
  },
}
