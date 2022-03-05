local t_action_state = require('telescope.actions.state')
local t_conf = require('telescope.config').values
local t_themes = require('telescope.themes')
local t_pickers = require('telescope.pickers')
local t_finders = require('telescope.finders')
local t_entry_display = require('telescope.pickers.entry_display')
local utils = require('project_run.utils')

local M = {}

M.list_picker = function(opts, results, runner)
  t_pickers.new(t_themes.get_dropdown(opts), {
    finder = t_finders.new_table({
      results = results,
      entry_maker = opts.entry_maker or M.make_entry_form_list,
    }),
    prompt_title = opts.prompt_title or 'Project commands',
    sorter = opts.sorter or t_conf.generic_sorter(opts),
    -- initial_mode = 'normal',
    -- default_selection_index = 2,
    attach_mappings = function(_, map)
      map('i', '<cr>', runner)
      map('n', '<cr>', runner)

      map('i', '<c-t>', M.actions.exit)
      map('i', '<c-v>', M.actions.exit)
      map('i', '<c-s>', M.actions.exit)
      map('n', '<c-t>', M.actions.exit)
      map('n', '<c-v>', M.actions.exit)
      map('n', '<c-s>', M.actions.exit)
      return true
    end,
  }):find()
end

M.make_entry_form_list = function(entry)
  local description = entry.description and entry.description or entry[1]
  local displayer = t_entry_display.create({
    separator = ' - ',
    items = {
      { width = 30 },
      { remaining = true },
    },
  })

  local make_display = function()
    return displayer({
      entry[1],
      { description, 'TelescopeResultsComment' },
    })
  end
  return { display = make_display, ordinal = entry[1], value = entry }
end

M.actions = {
  exit = require('telescope.actions').close,
  run_script = function(prompt_bufnr)
    local entry = t_action_state.get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    utils.open_tab(vim.fn.getcwd(), entry.value[2])
  end,
  run_cmd = function(prompt_bufnr)
    local entry = t_action_state.get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)

    entry.value[2](utils)
  end,
}

return M
