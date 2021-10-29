M = {
  ensure_installed = {'html', 'sumneko_lua', 'tailwindcss', 'tsserver', 'vimls', 'vuels', 'cssls', 'jsonls', 'emmet_ls'}
}

-- https://www.youtube.com/watch?v=tAVxxdFFYMU
M.rename_with_quickfix = function()
  local position_params = vim.lsp.util.make_position_params()

  local new_name = vim.fn.input({
    prompt='New Name: ',
    default=vim.fn.expand('<cword>')
  })
  if not (new_name and #new_name > 0) then return end

  position_params.newName = new_name

  -- vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, method, result, ...)
  vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, result, ctx, config)
    -- You can uncomment this to see what the result looks like.
    if false then
      print(vim.inspect(result))
    end
    -- vim.lsp.handlers["textDocument/rename"](err, method, result, ...)
    vim.lsp.handlers["textDocument/rename"](err, result, ctx, config)

    local entries = {}
    if result.changes then
      for uri, edits in pairs(result.changes) do
        local bufnr = vim.uri_to_bufnr(uri)

        for _, edit in ipairs(edits) do
          local start_line = edit.range.start.line + 1
          local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

          table.insert(entries, {
            bufnr = bufnr,
            lnum = start_line,
            col = edit.range.start.character + 1,
            text = line,
          })
        end
      end
    end

    vim.fn.setqflist(entries, "r")
  end)
end

M.install_essential_servers = function ()
  local installing_servers = false
  for _,  server_name in ipairs(M.ensure_installed) do
    local ok, server = require'nvim-lsp-installer.servers'.get_server(server_name)
    if ok then
      if not server:is_installed() then
        server:install()
        if not installing_servers then
          installing_servers = true
        end
      end
    end
  end

  if installing_servers then
    vim.cmd('LspInstallInfo')
  end
end

return M
