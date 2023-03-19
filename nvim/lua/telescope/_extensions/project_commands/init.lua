local _utils = require('hasan.utils')
local picker = require('telescope._extensions.project_commands.picker')
local utils = require('telescope._extensions.project_commands.utils')

local function scriptsCommandsFromJSON(script_file, opts)
  opts = _utils.merge({
    prompt_title = 'Script commands',
  }, opts or {})

  local exists, path = utils.root_has(script_file)
  if not exists or not path then
    print('Not found ' .. script_file)
    return 0
  end

  picker.list_picker(opts, utils.get_project_scripts(path.filename), picker.actions.run_script)
  vim.cmd([[normal! a]])
end

local function commands(opts)
  opts = _utils.merge({}, opts or {})
  local dynamic_commands = utils.conf.commands.dynamic_commands
  local command_list = {}
  if dynamic_commands ~= nil then
    command_list = dynamic_commands(utils)
  end
  local default_commands = utils.conf.commands.default_commands
  if #default_commands > 0 then
    for _, v in ipairs(default_commands) do
      table.insert(command_list, v)
    end
  end

  picker.list_picker(opts, command_list, picker.actions.run_cmd)
end

return require('telescope').register_extension({
  setup = function(opts)
    utils.conf = _utils.merge(utils.conf, opts or {})
  end,
  exports = {
    commands = commands,
    scriptsCommandsFromJSON = scriptsCommandsFromJSON,
  },
})
