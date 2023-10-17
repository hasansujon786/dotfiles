local lsp = vim.lsp
local api = vim.api
local M = {}

--------------------------------------------------
-------- Organize Imports ------------------------
--------------------------------------------------
local function make_organize_imports_params(bufnr)
  local arg1 = { path = api.nvim_buf_get_name(bufnr) }
  return { command = 'edit.organizeImports', arguments = { arg1 } }
end
function M.organize_imports_async(bufnr, post)
  bufnr = bufnr or api.nvim_get_current_buf()
  local method = 'workspace/executeCommand'
  lsp.buf_request(bufnr, method, make_organize_imports_params(bufnr), function(err)
    if not err and post then
      post()
    end
  end)
end

--------------------------------------------------
-------- Package to relative import --------------
--------------------------------------------------
local function filter_package_to_relative_import(results)
  local action = vim.tbl_filter(function(item)
    return item.kind == 'refactor.convert.packageToRelativeImport'
  end, results[1].result)

  if action then
    return action[1]
  end
  return nil
end
function M.package_to_relative_import(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local method = 'textDocument/codeAction'
  local options = {}
  local context = options.context or {}
  local params = vim.lsp.util.make_range_params()

  if not context.triggerKind then
    context.triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked
  end
  if not context.diagnostics then
    context.diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr)
  end
  params.context = context

  vim.lsp.buf_request_all(bufnr, method, params, function(results)
    local action = filter_package_to_relative_import(results)

    if action then
      vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')

      M.organize_imports_async(bufnr, function()
        vim.fn['repeat#set'](t('<Plug>FlutterPkgToRelative'))
      end)
    end
  end)
end

return M
