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

local function parse_project_commands()
  local all_commands = {}

  -- Get dynamic commands
  local dynamic_commands_func = utils.conf.dynamic_commands
  if dynamic_commands_func ~= nil and type(dynamic_commands_func) == 'function' then
    local dy_commands = dynamic_commands_func(utils)
    if dy_commands ~= nil and #dy_commands > 0 then
      all_commands = dy_commands
    end
  end

  -- Get default commands
  local default_commands = utils.conf.default_commands
  if type(default_commands) == 'table' and #default_commands > 0 then
    if #all_commands > 0 then
      for _, v in ipairs(default_commands) do
        table.insert(all_commands, v)
      end
    else
      all_commands = default_commands
    end
  end

  return all_commands
end

local function commands(opts)
  opts = _utils.merge({}, opts or {})
  local command_list = parse_project_commands()

  picker.list_picker(opts, command_list, picker.actions.run_cmd)
end

return require('telescope').register_extension({
  setup = function(opts)
    utils.conf = _utils.merge(utils.conf, opts or {})
  end,
  exports = {
    commands = commands,
    parse_project_commands = parse_project_commands,
    scriptsCommandsFromJSON = scriptsCommandsFromJSON,
  },
})
