local Path = require "plenary.path"
local entry_display = require('telescope.pickers.entry_display')
local t_action_state = require('telescope.actions.state')

local M = {
  user_util = {}
}
M.conf = {}

M.user_util.root_has = function (fname)
  local fpath = Path:new(vim.fn.getcwd(), fname)
  local exists = fpath:exists()
  return exists, exists and fpath or nil
end

M.user_util.get_project_scripts = function(fpath)
  local data = vim.fn.readfile(fpath)
  local sc = vim.fn.json_decode(data)['scripts']

  local list = {}
  for key, value in pairs(sc) do
    table.insert(list, {key, value})
  end
  return list
end

-- local lines = popup_file:readlines()
M.user_util.open_tab = function (dir, command_arg)
  if not command_arg then return end
  -- IMPORTNAT: add bash to Path
  if vim.fn.has('win32') == 1 then
    local winterm = 'silent !"c:\\Program Files\\WindowsApps\\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\\wt.exe"'
    local cmd = {winterm, '-w 0 nt -d', dir, '-p "Bash"', 'bash -c "source ~/dotfiles/bash/.env && ', command_arg, '"'}
    vim.cmd(table.concat(cmd, ' '))
  else
    -- vim.cmd('silent !tmux-windowizer $(pwd) ' .. entry.value[2])
    print('Project_run:WIP')
  end
end

M.actions = {
  exit = require('telescope.actions').close,
  run = function (prompt_bufnr)
    local entry = t_action_state.get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    M.user_util.open_tab(vim.fn.getcwd(), entry.value[2])
  end,
  run_cmd = function (prompt_bufnr)
    local entry = t_action_state.get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)

    entry.value[3](M.user_util)
    -- M.user_util.open_tab(vim.fn.getcwd(), entry.value[2])
  end,
}

-- M.commands()
-- local runOnStartupCB = function (callback)
--   callback({root_has = M.root_has})

--   vim.cmd[[
--   augroup Project_run
--     au!
--     au CursorHold * ++once lua require("hasan.project_run").on_startup()
--   augroup END
--   ]]
-- end

M.make_entry_form_list = function(entry)
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = 20 },
      { remaining = true },
    },
  }

  local make_display = function()
    return displayer {
      entry[1],
      { entry[2], 'TelescopeResultsComment' },
    }
  end
  return { display = make_display, ordinal = entry[1], value = entry}
end

return M
