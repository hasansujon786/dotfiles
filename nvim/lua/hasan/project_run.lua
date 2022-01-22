local t_conf = require('telescope.config').values
local t_utils = require('telescope.utils')
local themes = require('telescope.themes')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
-- local actions = require('telescope/actions')
-- local sorters = require('telescope/sorters')
local M = {}
local utils = require('hasan.utils.pr_utils')

M.scriptsCommandsFromJSON = function(script_file, opts)
  opts = t_utils.get_default(opts, {})
  local theme_opts = themes.get_dropdown(opts)

  local exists, path = utils.user_util.root_has(script_file)
  if not exists then
    print('Not found '.. script_file)
    return 0
  end

  pickers.new(theme_opts, {
    finder = finders.new_table{
      results = utils.user_util.get_project_scripts(path.filename),
      entry_maker = opts.entry_maker or utils.make_entry_form_list
    },
    prompt_title = opts.prompt_title or 'Project Script Commands',
    sorter = opts.sorter or t_conf.generic_sorter(opts),
    -- initial_mode = 'normal',
    -- default_selection_index = 2,
    attach_mappings = function(_, map)
      map('i', '<cr>',  utils.actions.run)
      map('n', '<cr>',  utils.actions.run)

      map('i', '<c-t>', utils.actions.exit)
      map('i', '<c-v>', utils.actions.exit)
      map('i', '<c-s>', utils.actions.exit)
      map('n', '<c-t>', utils.actions.exit)
      map('n', '<c-v>', utils.actions.exit)
      map('n', '<c-s>', utils.actions.exit)
      return true
    end,
  }):find()
  vim.cmd[[normal! a]]
end

M.commands = function(opts)
  opts = t_utils.get_default(opts, {})
  local theme_opts = themes.get_dropdown(opts)
  local on_startup = utils.conf.on_startup
  local command_list = {}

  if on_startup ~= nil then
    command_list = on_startup(utils.user_util)
  end
  local default_commands = utils.conf.default_commands
  if #default_commands > 0 then
    for _,v in ipairs(default_commands) do table.insert(command_list, v) end
  end

  pickers.new(theme_opts, {
    finder = finders.new_table{
      results = command_list,
      entry_maker = opts.entry_maker or utils.make_entry_form_list
    },
    prompt_title = opts.prompt_title or 'Project commands',
    sorter = opts.sorter or t_conf.generic_sorter(opts),
    -- initial_mode = 'normal',
    -- default_selection_index = 2,
    attach_mappings = function(_, map)
      map('i', '<cr>',  utils.actions.run_cmd)
      map('n', '<cr>',  utils.actions.run_cmd)

      map('i', '<c-t>', utils.actions.exit)
      map('i', '<c-v>', utils.actions.exit)
      map('i', '<c-s>', utils.actions.exit)
      map('n', '<c-t>', utils.actions.exit)
      map('n', '<c-v>', utils.actions.exit)
      map('n', '<c-s>', utils.actions.exit)
      return true
    end,
  }):find()
end

M.setup = function(opts)
  opts = opts and opts or {}

  utils.conf.on_startup = t_utils.get_default(opts.on_startup, nil)
  utils.conf.default_commands = t_utils.get_default(opts.default_commands, {})
end

return M
