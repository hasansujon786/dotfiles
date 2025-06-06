local Path = require('plenary.path')
local utils = require('telescope.utils')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local make_entry = require('telescope.make_entry')
local my_make_entry = require('hasan.telescope.make_entry_custom')
local my_theme = require('hasan.telescope.theme')
local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local local_action = require('hasan.telescope.local_action')
local extensions = require('telescope').extensions
local entry_display = require('telescope.pickers.entry_display')
-- local sorters = require 'telescope/sorters'

local conf = require('telescope.config').values
local os_sep = Path.path.sep

---@return boolean
local function buf_in_cwd(bufname, cwd)
  if cwd:sub(-1) ~= Path.path.sep then
    cwd = cwd .. Path.path.sep
  end
  local bufname_prefix = bufname:sub(1, #cwd)
  return bufname_prefix == cwd
end

-- if vim.fn.exists('g:hasan_telescope_buffers') == 0 then
--   vim.g.hasan_telescope_buffers = { ['0'] = 0 } -- used in hasan#utils#_buflisted_sorted()
-- end
-- autocmd('BufDelete', 'silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))')
-- autocmd({ 'BufWinEnter', 'WinEnter' }, 'let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())')
local git_and_buffer_files = function(opts)
  local cur_bufnr = vim.api.nvim_get_current_buf()
  local _buffer_keys = {}

  local buffer_files = vim
    .iter(vim.fn['hasan#utils#_buflisted_sorted']())
    :filter(function(b)
      if 1 ~= vim.fn.buflisted(b) then
        return false
      end
      if not opts.show_all_buffers and not vim.api.nvim_buf_is_loaded(b) then
        return false
      end
      if not opts.show_current_buffer and b == cur_bufnr then
        return false
      end
      return true
    end)
    :map(function(bufnr)
      local buffer_name = vim.api.nvim_buf_get_name(bufnr)
      if buffer_name == '' then
        return false
      end

      if opts.only_cwd and not buf_in_cwd(buffer_name, vim.uv.cwd()) then
        return false
      end

      local file = vim.fn.fnamemodify(buffer_name, ':.'):gsub('\\', '/')
      _buffer_keys[file] = 1
      return file
    end)
    :totable()

  local current_file = vim.fn.expand('%'):gsub('\\', '/')
  local git_results = utils.get_os_command_output({ 'git', 'ls-files', '--exclude-standard', '--cached', '--others' })
  local git_files = vim
    .iter(git_results)
    :filter(function(v)
      if _buffer_keys[v] == 1 then
        return false
      end
      return v ~= current_file
    end)
    :totable()

  pickers
    .new(opts, {
      prompt_title = 'Project Files',
      finder = finders.new_table({
        results = vim.iter({ buffer_files, git_files }):flatten():totable(),
        entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
      }),
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
      -- default_selection_index = 2,
      selection_strategy = 'reset', -- follow, reset, row
      color_devicons = true,
    })
    :find()
end

local M = {}

M.project_files = function()
  local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
  if ret == 0 then
    git_and_buffer_files(my_theme.get_top_panel({
      -- only_cwd = true,
      entry_maker = my_make_entry.gen_from_filename_first({ dir_separator = '/' }),
      attach_mappings = function(_, map)
        map({ 'n', 'i' }, '<CR>', actions.select_drop)
        return true
      end,
    }))
  else
    M.my_find_files()
  end
end

M.my_find_files = function(dir)
  builtin.find_files(my_theme.get_top_panel({
    cwd = dir == 'cur_dir' and vim.fn.expand('%:h') or nil,
    find_command = { 'rg', '--files', '--color', 'never', '--no-config', '--sortr=modified' },
  }))
end

M.references = function()
  builtin.lsp_references(my_theme.get_cursor_vertical())
end

function M.curbuf(is_visual)
  local word = is_visual and require('hasan.utils').get_visual_selection() or nil

  builtin.current_buffer_fuzzy_find(my_theme.get_dropdown({
    previewer = false,
    shorten_path = false,
    default_text = word,
  }))
end

function M.search_nvim_data()
  extensions.file_browser.file_browser({
    prompt_title = 'Nvim user data',
    cwd = vim.fn.stdpath('data'),
  })
end

function M.file_browser(dir)
  extensions.file_browser.file_browser({
    path = dir == 'cur_dir' and vim.fn.expand('%:h') or nil,
    hide_parent_dir = true,
    files = dir == 'cur_dir', -- false: start with all dirs
    prompt_path = true,
    previewer = true,
  })
end

local edit_projects_file = function(prompt_bufnr)
  require('telescope.actions').close(prompt_bufnr)
  vim.cmd.split(vim.fn.stdpath('data') .. '/project_nvim/project_history')
end
M.projects = function()
  extensions.projects.projects(my_theme.get_dropdown({
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

function M.grep_string(is_visual)
  local word = is_visual and require('hasan.utils').get_visual_selection() or vim.fn.input('Grep String: ')
  -- word = string.gsub(word, '%s+', '') -- remove spaces
  if word == '' then
    return
  end

  vim.fn.setreg('/', word)
  builtin.grep_string({ search = word })
end

M.grep_string_list = function(opts)
  opts = opts and opts or {}
  local search_pattern = opts.search_list

  if not search_pattern or search_pattern == '' or type(search_pattern) == 'table' and #search_pattern == 0 then
    vim.notify('Search list is required', vim.log.levels.WARN, { title = 'Telescope' })
    return
  end

  if type(search_pattern) == 'table' then
    search_pattern = table.concat(search_pattern, '|')
  end

  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == 'function' then
    additional_args = opts.additional_args(opts)
  end

  local args = vim.iter({ vimgrep_arguments, additional_args, { '-e', search_pattern } }):flatten():totable()

  if search_dirs then
    for _, path in ipairs(search_dirs) do
      table.insert(args, vim.fn.expand(path))
    end
  end

  pickers
    .new(my_theme.get_dropdown(opts), {
      prompt_title = 'Grep String List',
      finder = finders.new_oneshot_job(args, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

function M.search_project_todos()
  local todo_patern = table.concat(require('core.state').project.todo.keyfaces, ':|') .. ':' -- Creates "TODO :|DONE :|INFO :|..."
  M.grep_string_list({
    prompt_title = 'Search Todos',
    search_list = todo_patern,
    -- additional_args = function()
    --   return { '--glob', '!nvim/lua/hasan/core/state.lua', '--glob', '!nvim/legacy/*' }
    -- end,
  })
end

M.buffers = function(is_cwd_only)
  local opts = {
    prompt_title = is_cwd_only and 'Search buffers' or 'Search all buffers',
    cwd_only = is_cwd_only,
    sort_mru = true,
    sort_lastused = true,
    previewer = false,
    ignore_current_buffer = is_cwd_only,
    attach_mappings = function(_, map)
      map({ 'n', 'i' }, '<C-d>', actions.delete_buffer)
      map({ 'n' }, 'd', actions.delete_buffer)

      map({ 'n' }, 'l', actions.select_default)
      map({ 'n' }, 'o', actions.select_default)
      map({ 'n' }, 'v', actions.select_vertical)
      map({ 'n' }, 's', actions.select_horizontal)
      map({ 'n' }, 't', actions.select_tab)
      map({ 'n', 'i' }, '<CR>', actions.select_drop)
      return true
    end,
  }
  builtin.buffers(my_theme.get_dropdown(opts))
end

local function put_mappings(get_entry_value)
  if not get_entry_value then
    get_entry_value = function()
      local entry = action_state.get_selected_entry()
      return entry.value
    end
  end

  return function(_, map)
    map({ 'n', 'i' }, '<cr>', function(prompt_bufnr)
      local_action.put_emoji(prompt_bufnr, get_entry_value(), true)
    end)
    map({ 'n', 'i' }, '<C-t>', function(prompt_bufnr)
      local_action.put_emoji(prompt_bufnr, get_entry_value(), false)
    end)

    map('i', '<C-v>', nil)
    map('i', '<C-s>', nil)
    return true
  end
end

-- https://github.com/ikatyang/emoji-cheat-sheet#smileys--emotion
M.emojis = function()
  local emojis_table = vim.fn.readfile('c:/Users/hasan/dotfiles/bash/emojis.txt', '')
  local opts = { previewer = false }

  pickers
    .new(my_theme.get_top_panel(opts), {
      finder = finders.new_table({ results = emojis_table, entry_maker = make_entry.gen_from_string(opts) }),
      sorter = conf.file_sorter(opts),
      attach_mappings = put_mappings(function()
        local entry = action_state.get_selected_entry()
        return entry[1]:sub(1, 4)
      end),
    })
    :find()
end

local function get_tw_colors()
  local data = vim.fn.readfile('C:\\Users\\hasan\\dotfiles\\.system\\src\\tailwind_colors.json')
  local sc = vim.fn.json_decode(data)
  if sc == nil then
    return
  end

  local list = {}
  for group, scale_colors in pairs(sc) do
    for scale, hex in pairs(scale_colors) do
      table.insert(list, { group_name = group:lower(), scale = scale, hex = hex })
    end
  end
  return list
end

M.colors = function()
  local opts = { previewer = false }
  pickers
    .new(my_theme.get_top_panel(opts), {
      finder = finders.new_table({
        results = get_tw_colors(),
        entry_maker = my_make_entry.gen_from_tailwindcolors(opts),
      }),
      sorter = conf.file_sorter(opts),
      attach_mappings = put_mappings(),
    })
    :find()
end

M.auto_open_qflistt_or_loclist = function()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
  if #wininfo == 0 then
    return
  end

  local win = wininfo[1]
  vim.cmd([[cclose|lclose]])
  local list_type = win.loclist == 1 and 'loclist' or 'quickfix'
  require('telescope.builtin')[list_type]()
end

M.find_harpoon_file = function(harpoon_files)
  if type(harpoon_files.items) ~= 'table' or #harpoon_files.items == 0 then
    vim.notify('No harpoon files found', vim.log.levels.WARN, { title = 'Telescope' })
  end

  local harpoon_items = {}
  for index, item in ipairs(harpoon_files.items) do
    item.index_at = index
    table.insert(harpoon_items, item)
  end

  local opts = {}
  local disable_devicons = opts.disable_devicons

  local original_entry_maker = make_entry.gen_from_string(opts)

  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 2 },
      { width = 2 },
      { remaining = true },
    },
  })

  local entry_maker = function(item)
    local original_entry = original_entry_maker(item.value)

    original_entry.display = function(entry)
      local display_filename, path_style = utils.transform_path(opts, entry.value)

      local icon, hl_group = utils.get_devicons(entry.value, disable_devicons)

      return displayer({
        { item.index_at, 'TelescopeResultsNumber' },
        { icon, hl_group },
        {
          display_filename,
          function()
            return path_style
          end,
        },
      })
    end

    return original_entry
  end

  require('telescope.pickers')
    .new(my_theme.get_dropdown(opts), {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table({
        results = harpoon_items,
        entry_maker = entry_maker,
      }),
      previewer = conf.file_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return M
