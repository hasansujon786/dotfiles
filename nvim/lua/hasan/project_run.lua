local entry_display = require('telescope.pickers.entry_display')
local utils = require('telescope.utils')
local themes = require('telescope.themes')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
-- local actions = require('telescope/actions')
local action_state = require('telescope.actions.state')
-- local sorters = require('telescope/sorters')
local conf = require('telescope.config').values

local get_project_scripts = function(fpath)
  local data = vim.fn.readfile(fpath)
  local sc = vim.fn.json_decode(data)['scripts']
  -- local list = keys()

  local list = {}
  for key, value in pairs(sc) do
    table.insert(list, {key, value})
  end
  return list
end

local local_actions = {
  run = function (prompt_bufnr)
    local entry = action_state.get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    if vim.fn.has('win32') == 1 then
      vim.fn.setreg('*', {'yarn '..entry.value[1]})
      local cmd = 'silent !"c:\\Program Files\\WindowsApps\\Microsoft.WindowsTerminal_1.10.2714.0_x64__8wekyb3d8bbwe\\wt.exe" '
      cmd  = cmd .. '-w 0 nt -d .'
      vim.cmd(cmd)
    else
      vim.cmd('silent !tmux-windowizer $(pwd) ' .. entry.value[2])
    end
  end,
}
local make_entry_form_scripts = function(entry)
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

local M = {}

M.run = function(scriptFile, opts)
  opts = utils.get_default(opts, {})
  local themeOpts = themes.get_dropdown(opts)

  local fpath = vim.fn.getcwd() ..'/'.. scriptFile
  local exists = vim.fn.filereadable(fpath) == 1
  if not exists then
    print('Not found '.. scriptFile)
    return 0
  end

  pickers.new(themeOpts, {
    finder = finders.new_table{
      results = get_project_scripts(fpath),
      entry_maker = opts.entry_maker or make_entry_form_scripts
    },
    prompt_title = opts.prompt_title or 'YankList',
    sorter = opts.sorter or conf.generic_sorter(opts),
    -- initial_mode = 'normal',
    -- previewer = conf.file_previewer(opts),
    -- default_selection_index = 2,
    attach_mappings = function(_, map)
      map('i', '<cr>',  local_actions.run)
      map('n', '<cr>',  local_actions.run)
      -- map('i', '<c-t>', local_actions.putup)
      -- map('n', '<c-t>', local_actions.putup)
      -- map('i', '<c-y>', local_actions.yank)
      -- map('n', '<c-y>', local_actions.yank)
      return true
    end,
  }):find()
end

-- M.run()
return M
