local M = {}
local api = vim.api

function M.get_global_conf()
  return require('config.lsp.util.configs')
end

function M.get_server_conf(lsp_name)
  local ok, module = pcall(require, 'config.lsp.servers.' .. lsp_name)
  if ok then
    return module
  end
  return nil
end

function M.install_essential_servers()
  local ok, registry = pcall(require, 'mason-registry')
  if not ok then
    print('[Mason] Please install mason and try again')
  end
  local g_conf = M.get_global_conf()

  -- Get mason server names to install
  local masaon_pkgs = g_conf.extra_tools
  for _, s_value in pairs(g_conf.essential_servers) do
    table.insert(masaon_pkgs, s_value[1])
  end

  -- Get not installed servers
  local not_installed_servers = {}
  for _, server_name in ipairs(masaon_pkgs) do
    if not registry.is_installed(server_name) then
      table.insert(not_installed_servers, server_name)
    end
  end

  if #not_installed_servers > 0 then
    require('mason.api.command').MasonInstall(not_installed_servers)
  else
    print('[Mason] All pkgs were already installed')
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

M._lspRenameChangeList = nil
function M.showLspRenameChanges()
  local entries = {}
  if not M._lspRenameChangeList then
    return
  end

  for uri, edits in pairs(M._lspRenameChangeList) do
    local bufnr = vim.uri_to_bufnr(uri)
    for _, edit in ipairs(edits) do
      local start_line = edit.range.start.line + 1
      local line = api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]
      table.insert(entries, {
        bufnr = bufnr,
        lnum = start_line,
        col = edit.range.start.character + 1,
        text = line,
      })
    end
  end
  vim.fn.setqflist(entries, 'r')

  vim.cmd([[copen]])
end

local function _lspRename(value)
  local lsp_params = vim.lsp.util.make_position_params()
  if not value or #value == 0 then
    return
  end

  -- request lsp rename
  lsp_params.newName = value
  vim.lsp.buf_request(0, 'textDocument/rename', lsp_params, function(err, res, ctx, _)
    if err then
      vim.notify(('Error running lsp query "%s": %s'):format('textDocument/rename', err), vim.log.levels.ERROR)
      return
    end
    if not res then
      return
    end

    -- apply renames
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

    -- print renames
    local changed_files_count = 0
    local changed_instances_count = 0

    if res.documentChanges then
      for _, changed_file in pairs(res.documentChanges) do
        changed_files_count = changed_files_count + 1
        changed_instances_count = changed_instances_count + #changed_file.edits
      end
    elseif res.changes then
      for _, changed_file in pairs(res.changes) do
        changed_instances_count = changed_instances_count + #changed_file
        changed_files_count = changed_files_count + 1
      end
      M._lspRenameChangeList = res.changes
    end

    -- compose the right print message
    vim.notify(
      string.format(
        'renamed %s instance%s in %s file%s. %s',
        changed_instances_count,
        changed_instances_count == 1 and '' or 's',
        changed_files_count,
        changed_files_count == 1 and '' or 's',
        changed_files_count > 1 and "To save them run ':wa'" or ''
      ),
      vim.log.levels.INFO
    )
  end)
end

function M.lspRename()
  -- https://www.youtube.com/watch?v=tAVxxdFFYMU
  -- local tshl = require('nvim-treesitter-playground.hl-info').get_treesitter_hl()
  -- if tshl and #tshl > 0 then
  --   local ind = tshl[#tshl]:match('^.*()%*%*.*%*%*')
  --   tshl = tshl[#tshl]:sub(ind + 2, -3)
  -- end
  local currName = vim.fn.expand('<cword>')

  local opt = { prompt = 'Rename', default = currName }
  require('hasan.utils.widgets').get_input(opt, function(newName)
    if newName and newName ~= currName then
      _lspRename(newName)
    end
  end)
end

---Open quickfix with current ref focused
function M.references_and_focus_cur_ref()
  local qf_line_left_fmt = '%s │%5d:%-3d│'
  local search_cmd_fmt = "call search('%s')"
  vim.fn['hasan#utils#feedkeys']('viwo<ESC>', 'n')

  vim.defer_fn(function()
    local cursor = api.nvim_win_get_cursor(0)
    local line_nr = cursor[1]
    local col_nr = cursor[2] + 1
    local fname = require('hasan.utils.ui.qf').valid_qf_fname(api.nvim_get_current_buf())
    fname = fname:gsub('\\', '\\\\')

    vim.lsp.buf.references()
    vim.defer_fn(function()
      local search_current_ref_cmd = search_cmd_fmt:format(qf_line_left_fmt:format(fname, line_nr, col_nr))
      vim.cmd(search_current_ref_cmd)
    end, 200)
  end, 20)
end

return M
