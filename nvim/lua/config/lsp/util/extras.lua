local M = {}
local api = vim.api

function M.get_lspconfig(lsp_name)
  local local_conf = M.import_server_local_module(lsp_name)
  if local_conf ~= nil and local_conf.opts ~= nil then
    return require('hasan.utils').merge(M.get_setup_opts().default_opts, local_conf.opts)
  end

  return M.get_setup_opts().default_opts
end

function M.get_setup_opts()
  return require('config.lsp.util.setup')
end

function M.import_server_local_module(lsp_name)
  local ok, module = pcall(require, 'config.lsp.servers.' .. lsp_name)
  if ok then
    return module
  end
  return nil
end

function M.update_capabilities(fname)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local blink_ok, blink_cmp = pcall(require, 'blink.cmp')
  if blink_ok then
    return blink_cmp.get_lsp_capabilities(capabilities)
  end

  local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_ok then
    return vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
  end

  vim.notify('Capabilities not updated with ' .. fname, vim.log.levels.WARN, { title = 'lsp-config' })
  return capabilities
end

function M.execute(action, bufnr, on_complete)
  bufnr = bufnr or 0
  -- on_complete = on_complete and utils.lsp_handler(on_complete) or nil
  -- textDocument/codeAction can return either Command[] or CodeAction[].
  -- If it is a CodeAction, it can have either an edit, a command or both.
  -- Edits should be executed first
  if action.edit or type(action.command) == 'table' then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
    end
    if type(action.command) == 'table' then
      vim.lsp.buf_request(bufnr, 'workspace/executeCommand', action.command, on_complete)
    else
      on_complete()
    end
  else
    vim.lsp.buf_request(bufnr, 'workspace/executeCommand', action, on_complete)
  end
end

function M.install_essential_servers()
  local ok, registry = pcall(require, 'mason-registry')
  if not ok then
    print('[Mason] Please install mason and try again')
  end
  local g_conf = M.get_setup_opts()

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
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not res or client == nil then
      return
    end

    -- apply renames
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

  vim.ui.input({
    prompt = 'Rename',
    default = currName,
    win = { style = 'input_cursor', width = math.max(#currName + 6, 30) },
  }, function(newName)
    if newName and newName ~= currName then
      _lspRename(newName)
    end
  end)
end

return M
