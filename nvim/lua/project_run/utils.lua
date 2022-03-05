local Path = require('plenary.path')
local M = { conf = {} }

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
M.open_tab = function(dir, cmd_arg)
  if not cmd_arg then
    return
  end
  local cmd = {}
  if vim.fn.has('win32') == 1 then
    local winTermPath =
      'silent !"c:\\Program Files\\WindowsApps\\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\\wt.exe"'
    local profile = '-p "Bash" C:\\Program Files\\Git\\bin\\bash'
    local command_str = '-c "source ~/dotfiles/bash/.env && %s"'

    cmd = { winTermPath, '-w 0 nt -d', dir, profile, command_str:format(cmd_arg) }
  else
    -- vim.cmd('silent !tmux-windowizer $(pwd) ' .. entry.value[2])
    print('Project_run:WIP')
    return
  end

  vim.cmd(table.concat(cmd, ' '))
end

return M
