local t_conf = require('telescope.config').values
local t_utils = require('telescope.utils')
local themes = require('telescope.themes')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
-- local actions = require('telescope/actions')
-- local sorters = require('telescope/sorters')
local M = {}
local utils = require('hasan.utils.pr_utils')

M.open = function(scriptFile, opts)
  opts = t_utils.get_default(opts, {})
  local theme_opts = themes.get_dropdown(opts)

  local fpath = vim.fn.getcwd() ..'/'.. scriptFile
  local exists = vim.fn.filereadable(fpath) == 1
  if not exists then
    print('Not found '.. scriptFile)
    return 0
  end

  pickers.new(theme_opts, {
    finder = finders.new_table{
      results = utils.user_util.get_project_scripts(fpath),
      entry_maker = opts.entry_maker or utils.make_entry_form_list
    },
    prompt_title = opts.prompt_title or 'Project Run',
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
end

M.commands = function(opts)
  opts = t_utils.get_default(opts, {})
  local theme_opts = themes.get_dropdown(opts)
  local commandList = utils.conf.on_startup(utils.user_util)

  pickers.new(theme_opts, {
    finder = finders.new_table{
      results = commandList,
      entry_maker = opts.entry_maker or utils.make_entry_form_list
    },
    prompt_title = opts.prompt_title or 'Project Run',
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
end

return M
