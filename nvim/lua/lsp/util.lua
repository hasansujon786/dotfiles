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

-- https://www.youtube.com/watch?v=tAVxxdFFYMU
M.rename_with_quickfix = function()
  local rename = 'textDocument/rename'
  local currName = vim.fn.expand('<cword>')
  -- local tshl = require('nvim-treesitter-playground.hl-info').get_treesitter_hl()
  -- if tshl and #tshl > 0 then
  --   local ind = tshl[#tshl]:match('^.*()%*%*.*%*%*')
  --   tshl = tshl[#tshl]:sub(ind + 2, -3)
  -- end
  local add_changes_quickfix = function(changes)
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

  local win = require('plenary.popup').create(currName, {
    title = 'New Name',
    style = 'minimal',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    relative = 'cursor',
    borderhighlight = 'FloatBorder',
    titlehighlight = 'Title',
    highlight = 'Float',
    focusable = true,
    width = 25,
    height = 1,
    line = 'cursor+2',
    col = 'cursor-1'
  })

  local map_opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(0, 'i', '<Esc>', '<cmd>stopinsert | q!<CR>', map_opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', '<cmd>stopinsert | q!<CR>', map_opts)
  vim.api.nvim_buf_set_keymap(0, 'i', '<CR>', '<cmd>stopinsert | lua _rename("'..currName..'")<CR>', map_opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<cmd>stopinsert | lua _rename("'..currName..'")<CR>', map_opts)
  vim.api.nvim_buf_set_option(0, 'filetype', 'Prompt')

  local function handler(err, result, ctx, config)
    if err then vim.notify(('Error running lsp query "%s": %s'):format(rename, err), vim.log.levels.ERROR) end
    if result and result.changes then
      -- notify_changes(result.changes)
      add_changes_quickfix(result.changes)
    end
    vim.lsp.handlers[rename](err, result, ctx, config)
  end

  function _G._rename(curr)
    local newName = vim.trim(vim.fn.getline('.'))
    vim.api.nvim_win_close(win, true)
    if #newName > 0 and newName ~= curr then
      local position_params = vim.lsp.util.make_position_params()
      position_params.newName = newName
      vim.lsp.buf_request(0, rename, position_params, handler)
    end
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
-- end

return M
