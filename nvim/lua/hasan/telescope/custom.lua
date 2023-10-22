local Path = require('plenary.path')
local utils = require('telescope.utils')
local themes = require('telescope.themes')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local make_entry = require('telescope.make_entry')
local my_make_entry = require('hasan.telescope.make_entry_custom')
local my_theme = require('hasan.telescope.theme')
local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local extensions = require('telescope').extensions
-- local sorters = require 'telescope/sorters'

local local_action = require('hasan.telescope.local_action')
local conf = require('telescope.config').values
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
    local file = vim.fn.fnamemodify(bufname, ':.'):gsub('\\', '/')
    table.insert(bufer_files, file)
  end
  local current_file = vim.fn.expand('%'):gsub('\\', '/')
  local git_files = utils.get_os_command_output({ 'git', 'ls-files', '--exclude-standard', '--cached', '--others' })
  git_files = filter(function(v)
    return v ~= current_file
  end, git_files)
  local fusedArray = flatten({ bufer_files, git_files })

  pickers
    .new(opts, {
      prompt_title = 'Project Files',
      finder = finders.new_table({
        results = vim.fn['hasan#utils#_uniq'](fusedArray),
        entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
      }),
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
    })
    :find()
end

local M = {}

M.project_files = function()
  local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
  if ret == 0 then
    git_and_buffer_files(my_theme.get_top_panel({
      entry_maker = my_make_entry.gen_from_file({ dir_separator = '/' }),
    }))
  else
    M.my_find_files()
  end
end

M.my_find_files = function()
  builtin.find_files(my_theme.get_top_panel({
    entry_maker = my_make_entry.gen_from_file(),
  }))
end

function M.curbuf()
  local opts = themes.get_dropdown({
    border = true,
    previewer = false,
    shorten_path = false,
  })
  if require('hasan.utils').is_visual_mode() then
    local word = require('hasan.utils').get_visual_selection()
    opts.default_text = word
    vim.fn.setreg('/', word)
  end

  builtin.current_buffer_fuzzy_find(opts)
end

function M.search_wiki_files()
  builtin.find_files(my_theme.get_top_panel({
    prompt_title = 'Search Wiki',
    cwd = _G.org_root_path,
    previewer = false,
    entry_maker = my_make_entry.gen_from_file(),
    -- search_dirs = {
    --   '3_resources/wiki/',
    -- },
  }))
end

function M.grep_org_text()
  builtin.live_grep({
    results_title = 'Org Texts',
    prompt_title = 'Search Org Texts',
    path_display = { 'smart' },
    cwd = _G.org_root_path,
  })
end

function M.search_plugins()
  extensions.file_browser.file_browser(themes.get_ivy({
    previewer = false,
    prompt_title = 'Plugins',
    cwd = vim.fn.glob(_G.plugin_path),
  }))
end

function M.search_nvim_data()
  extensions.file_browser.file_browser(themes.get_ivy({
    previewer = true,
    prompt_title = 'Nvim user data',
    cwd = vim.fn.stdpath('data'),
  }))
end

function M.file_browser(dir)
  extensions.file_browser.file_browser(themes.get_ivy({
    path = dir == 'cur_dir' and vim.fn.expand('%:h') or nil,
    hide_parent_dir = true,
    files = dir == 'cur_dir', -- false: start with all dirs
    prompt_path = true,
    previewer = false,
  }))
end

M.projects = function()
  local edit_projects_file = function(prompt_bufnr)
    require('telescope.actions').close(prompt_bufnr)
    vim.cmd('split ' .. vim.fn.stdpath('data') .. '/project_nvim/project_history')
  end
  require('telescope._extensions').manager.projects.projects(themes.get_dropdown({
    attach_mappings = function(_, map)
      map('i', '<C-e>', edit_projects_file)
      map('n', '<C-e>', edit_projects_file)
      return true
    end,
  }))
end

M.live_grep_in_folder = function(opts)
  opts = opts or {}
  local data = {}
  require('plenary.scandir').scan_dir(vim.loop.cwd(), {
    hidden = opts.hidden,
    only_dirs = true,
    respect_gitignore = true,
    on_insert = function(entry)
      table.insert(data, entry .. os_sep)
    end,
  })
  table.insert(data, 1, '.' .. os_sep)

  pickers
    .new(opts, {
      prompt_title = 'Folders for Live Grep',
      results_title = false,
      finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
      sorting_strategy = 'ascending',
      layout_strategy = 'horizontal',
      layout_config = {
        prompt_position = 'top',
        anchor = 'N',
        width = 0.7,
        -- height = 0.6,
      },
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
          actions.close(prompt_bufnr)
          -- require('telescope.builtin').live_grep { search_djirs = dirs }
          builtin.live_grep({ cwd = dirs[1] })
        end)
        return true
      end,
    })
    :find()
end

M.commands = function()
  builtin.commands(my_theme.get_top_panel())
end

function M.grep_string()
  local isVisual = require('hasan.utils').is_visual_mode()
  local word = nil

  if isVisual then
    word = require('hasan.utils').get_visual_selection()
  else
    word = vim.fn.input('Grep String: ')
  end

  -- word = string.gsub(word, '%s+', '') -- remove spaces
  if word == '' then
    return
  end

  vim.fn.setreg('/', word)
  builtin.grep_string({ search = word })
end

M.grep_string_list = function(opts)
  opts = opts and opts or {}

  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  local search_list = {}
  if opts.search_list and #opts.search_list > 0 then
    for _, value in ipairs(opts.search_list) do
      table.insert(search_list, '-e')
      table.insert(search_list, value)
    end
  end

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == 'function' then
    additional_args = opts.additional_args(opts)
  end

  local args = flatten({ vimgrep_arguments, additional_args, search_list })

  if search_dirs then
    for _, path in ipairs(search_dirs) do
      table.insert(args, vim.fn.expand(path))
    end
  end

  pickers
    .new(themes.get_dropdown(opts), {
      prompt_title = 'Grep String List',
      finder = finders.new_oneshot_job(args, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

function M.search_project_todos()
  M.grep_string_list({
    prompt_title = 'Search Todos',
    path_display = { 'smart' },
    search_list = require('hasan.core.state').telescope.todo_keyfaces,
    additional_args = function()
      return { '--glob', '!nvim/lua/hasan/core/state.lua', '--glob', '!nvim/legacy/*' }
    end,
  })
end

M.buffers = function(is_cwd_only)
  local opts = {
    prompt_title = is_cwd_only and 'Search buffers' or 'Search all buffers',
    cwd_only = is_cwd_only,
    sort_mru = true,
    previewer = false,
    ignore_current_buffer = is_cwd_only,
    entry_maker = my_make_entry.gen_from_buffer({
      bufnr_width = 3,
      sort_mru = true,
    }),
  }
  builtin.buffers(themes.get_dropdown(opts))
end

-- https://github.com/ikatyang/emoji-cheat-sheet#smileys--emotion
M.emojis = function()
  local emojis_table = vim.fn.readfile('c:/Users/hasan/dotfiles/bash/emojis.txt', '')
  local opts = {
    previewer = false,
    put_emoji = function(prompt_bufnr, cmd)
      require('telescope.actions').close(prompt_bufnr)
      local visual = false
      local entry = action_state.get_selected_entry()
      local oldReg = { vim.fn.getreg('0'), vim.fn.getregtype('0') }

      local emo = entry[1]:sub(1, 4)
      vim.fn.setreg('0', emo, 'v')
      vim.cmd('normal! ' .. (visual and 'gv' or 'h') .. '"0' .. cmd .. 'll')

      vim.defer_fn(function()
        vim.fn.setreg('0', oldReg[1], oldReg[2])
      end, 100)
    end,
  }

  pickers
    .new(my_theme.get_top_panel(opts), {
      finder = finders.new_table({
        results = emojis_table,
        entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),
      }),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(_, map)
        map('n', '<cr>', function(prompt_bufnr)
          opts.put_emoji(prompt_bufnr, 'p')
        end)
        map('n', '<C-t>', function(prompt_bufnr)
          opts.put_emoji(prompt_bufnr, 'P')
        end)

        map('i', '<cr>', function(prompt_bufnr)
          opts.put_emoji(prompt_bufnr, 'p')
        end)
        map('i', '<C-t>', function(prompt_bufnr)
          opts.put_emoji(prompt_bufnr, 'P')
        end)

        map('i', '<C-v>', nil)
        map('i', '<C-s>', nil)
        return true
      end,
    })
    :find()
end

return M
