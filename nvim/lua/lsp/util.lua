local M = {}

M.install_essential_servers = function()
  local essential_servers = {
    'html',
    'vimls',
    'vuels',
    'cssls',
    'jsonls',
    'tsserver',
    'emmet_ls',
    'tailwindcss',
    'sumneko_lua',
  }
  local installing_servers = false
  for _,  server_name in ipairs(essential_servers) do
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

-- local notify_changes = function(changes)
--   local new
--   local msg = ''
--   for f, c in pairs(changes) do
--     new = c[1].newText
--     msg = msg..('%d changes -> %s'):format(#c, f:gsub("file://",""):gsub(fn.getcwd(),".")).."\n"
--     msg = msg:sub(1, #msg - 1)
--     vim.notify(msg, vim.log.levels.INFO, { title = ('Rename: %s -> %s'):format(currName, new) })
--   end

local function rename_handler(err, result, ctx, config)
  local add_changes_to_quickfix = function(changes)
    local entries = {}
    if changes then
      for uri, edits in pairs(changes) do
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
    vim.fn.setqflist(entries, 'r')
  end

  if err then vim.notify(('Error running lsp query "%s": %s'):format('textDocument/rename', err), vim.log.levels.ERROR) end
  if result and result.changes then
    -- notify_changes(result.changes)
    add_changes_to_quickfix(result.changes)
  end
  vim.lsp.handlers['textDocument/rename'](err, result, ctx, config)
end

-- https://www.youtube.com/watch?v=tAVxxdFFYMU
M.rename_with_quickfix = function()
  -- local tshl = require('nvim-treesitter-playground.hl-info').get_treesitter_hl()
  -- if tshl and #tshl > 0 then
  --   local ind = tshl[#tshl]:match('^.*()%*%*.*%*%*')
  --   tshl = tshl[#tshl]:sub(ind + 2, -3)
  -- end
  local currName = vim.fn.expand('<cword>')

  require('hasan.utils.ui').input('Rename', {
    default_value = currName,
    on_submit = function(newName)
      if #newName > 0 and newName ~= currName then
        local position_params = vim.lsp.util.make_position_params()
        position_params.newName = newName
        vim.lsp.buf_request(0, 'textDocument/rename', position_params, rename_handler)
      end
    end,
  })
end

return M
