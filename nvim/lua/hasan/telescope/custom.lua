local Path = require 'plenary.path'
local scan = require 'plenary.scandir'
local utils = require 'telescope.utils'
local themes = require 'telescope.themes'
local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local make_entry = require 'telescope.make_entry'
local action_set = require 'telescope.actions.set'
local action_state = require 'telescope.actions.state'
-- local sorters = require 'telescope/sorters'

local local_action = require 'hasan.telescope.local_action'
local conf = require 'telescope.config'.values
local os_sep = Path.path.sep

local filter = vim.tbl_filter
local flatten = vim.tbl_flatten

local git_and_buffer_files = function(opts)
  local bufnrs = filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      return false
    end
    if not opts.show_all_buffers and not vim.api.nvim_buf_is_loaded(b) then
      return false
    end
    if not opts.show_current_buffer and b == vim.api.nvim_get_current_buf() then
      return false
    end
    if opts.only_cwd and not string.find(vim.api.nvim_buf_get_name(b), vim.loop.cwd(), 1, true) then
      return false
    end
    return true
  end, vim.fn['hasan#utils#_buflisted_sorted']())

  local bufer_files = {}
  for _, bufnr in ipairs(bufnrs) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local file = vim.fn.fnamemodify(bufname, ':.'):gsub('\\','/')
    table.insert(bufer_files, file)
  end
  local current_file = vim.fn.expand('%'):gsub('\\','/')
  local git_files = utils.get_os_command_output({ 'git', 'ls-files', '--exclude-standard', '--cached', '--others' })
  git_files = filter(function(v) return v ~= current_file end, git_files)
  local fusedArray = flatten({bufer_files, git_files})

  pickers.new(opts, {
    finder = finders.new_table{
      results = vim.fn['hasan#utils#_uniq'](fusedArray),
      entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
    },
    sorter = conf.file_sorter(opts),
    previewer = conf.file_previewer(opts),
    -- default_selection_index = 2,
    selection_strategy = 'reset', -- follow, reset, row
    color_devicons = true,
    attach_mappings = function(_, map)
      map('i', '<cr>', local_action.edit)
      map('i', '<C-v>', local_action.vsplit)
      map('i', '<C-s>', local_action.split)
      map('i', '<C-t>', local_action.tabedit)

      -- A return value _must_ be returned. It is an error to not return anything.
      -- Return false if you don't want any other mappings applied.
      return true
    end,
  }):find()
end


local M = {}

M.project_files = function()
  local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
  local gopts = {
    prompt_title = 'Project Files',
    prompt_prefix = '  ',
  }
  if ret == 0 then
    git_and_buffer_files(gopts)
  else
    builtin.find_files()
  end
end

function M.git_files()
  local opts = themes.get_dropdown {
    winblend = 5,
    previewer = false,
    shorten_path = false,
    prompt_prefix = '  ',

    layout_config = {
      width = 0.25,
    },
  }

  builtin.git_files(opts)
end

function M.curbuf()
  local opts = themes.get_dropdown {
    border = true,
    previewer = false,
    shorten_path = false,
  }
  builtin.current_buffer_fuzzy_find(opts)
end

function M.search_wiki_files()
  builtin.find_files({
      prompt_title = 'Org files',
      cwd = '~/vimwiki',
      previewer = false
    })
end

function M.search_plugins()
  builtin.file_browser(themes.get_ivy({
    prompt_title = 'Plugins',
    cwd = vim.fn.glob(vim.fn.stdpath('data') .. '/site/pack/packer'),
  }))
end

function M.grep_string()
  local string = vim.fn.input('Grep String: ')
  builtin.grep_string({ search = string })
end

function M.file_browser(dir)
  local opts = {}
  local cwd = vim.fn.expand('%:h')
  if dir == 'cur_dir' and cwd ~= '' then
    opts = {cwd=cwd}
  end
  builtin.file_browser(themes.get_ivy(opts))
end

function M.file_files(dir)
  local opts = {}
  local cwd = vim.fn.expand('%:h')
  if dir == 'cur_dir' and cwd ~= '' then
    opts = {cwd=cwd}
  end
  builtin.find_files(themes.get_ivy(opts))
end

M.projects = function ()
  local edit_projects_file = function(prompt_bufnr)
    require('telescope.actions').close(prompt_bufnr)
    vim.cmd('split '.. vim.fn.stdpath('data')..'/project_nvim/project_history')
  end
  local projects_options = {
    attach_mappings = function(_, map)
      map('i', '<C-e>', edit_projects_file)
      map('n', '<C-e>', edit_projects_file)
      return true
    end,
  }
  require('telescope._extensions').manager.projects.projects(themes.get_dropdown(projects_options))
end

M.live_grep_in_folder = function(opts)
  opts = opts or {}
  local data = {}
  scan.scan_dir(vim.loop.cwd(), {
    hidden = opts.hidden,
    only_dirs = true,
    respect_gitignore = true,
    on_insert = function(entry)
      table.insert(data, entry .. os_sep)
    end,
  })
  table.insert(data, 1, '.' .. os_sep)

  pickers.new(opts, {
    prompt_title = 'Folders for Live Grep',
    finder = finders.new_table { results = data, entry_maker = make_entry.gen_from_file(opts) },
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      action_set.select:replace(function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local dirs = {}
        local selections = current_picker:get_multi_selection()
        if vim.tbl_isempty(selections) then
          table.insert(dirs, action_state.get_selected_entry().value)
        else
          for _, selection in ipairs(selections) do
            table.insert(dirs, selection.value)
          end
        end
        actions._close(prompt_bufnr, current_picker.initial_mode == 'insert')
        -- require('telescope.builtin').live_grep { search_djirs = dirs }
        require('telescope.builtin').live_grep { cwd = dirs[1] }
      end)
      return true
    end,
  }):find()
end

return M
