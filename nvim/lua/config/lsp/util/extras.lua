local M = {}

---Get lsp server config
---@param lsp_name string
---@return lsp.ServerConfig|nil
function M.import_lspconfig_by_name(lsp_name)
  local ok, module = pcall(require, 'config.lsp.servers.' .. lsp_name)
  if ok then
    return module
  end
  return nil
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

  local lsp_state = require('core.state').lsp

  -- Get mason server names to install
  local masaon_pkgs = lsp_state.extra_tools
  for _, s_value in pairs(lsp_state.essential_servers) do
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
      vim.lsp.buf.rename(newName)
    end
  end)
end

function M.hover()
  local img_src = nil
  Snacks.image.doc.at_cursor(function(src, _)
    img_src = src
  end)
  if not img_src then
    img_src = require('hasan.utils.buffer').parse_img_str_at_cursor()
  end

  if img_src then
    require('hasan.utils.file').quicklook({ img_src })
  end
end

return M
