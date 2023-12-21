local Path = require('plenary.path')
local M = {
  conf = {
    default_commands = nil,
    dynamic_commands = nil,
    open_tab_func = nil,
  },
}

M.root_has = function(fname)
  local fpath = Path:new(vim.fn.getcwd(), fname)
  local exists = fpath:exists()
  return exists, exists and fpath or nil
end

M.get_project_scripts = function(fpath)
  local data = vim.fn.readfile(fpath)
  local sc = vim.fn.json_decode(data)['scripts']

  local list = {}
  for key, value in pairs(sc) do
    table.insert(list, { key, value })
  end
  return list
end

-- local lines = popup_file:readlines()
M.open_tab = function(cwd, user_cmd, opts)
  if not user_cmd or not cwd then
    return
  end

  if M.conf.open_tab_func ~= nil and type(M.conf.open_tab_func) == 'function' then
    return M.conf.open_tab_func(cwd, user_cmd, opts)
  end
end
-- require("telescope._extensions.project_commands.utils").conf
return M
