-- local telescope = require('telescope')
local _utils = require('hasan.utils')
local picker = require('project_run.picker')
local utils = require('project_run.utils')

local M = {}

M.scriptsCommandsFromJSON = function(script_file, opts)
  opts = _utils.merge({
    prompt_title = 'Script commands',
  }, opts or {})

  local exists, path = utils.root_has(script_file)
  if not exists then
    print('Not found ' .. script_file)
    return 0
  end
  picker.list_picker(opts, utils.get_project_scripts(path.filename), picker.actions.run_script)
  vim.cmd([[normal! a]])
end

M.commands = function(opts)
  opts = _utils.merge({}, opts or {})
  local dynamic_commands = utils.conf.dynamic_commands
  local command_list = {}
  if dynamic_commands ~= nil then
    command_list = dynamic_commands(utils)
  end
  local default_commands = utils.conf.default_commands
  if #default_commands > 0 then
    for _, v in ipairs(default_commands) do
      table.insert(command_list, v)
    end
  end

  picker.list_picker(opts, command_list, picker.actions.run_cmd)
end

M.setup = function(opts)
  opts = _utils.merge({
    default_commands = {},
    dynamic_commands = nil,
  }, opts or {})

  utils.conf.dynamic_commands = opts.dynamic_commands
  utils.conf.default_commands = opts.default_commands
end

return M
