local local_action = require('hasan.telescope.local_action')
local builtin = require('telescope.builtin')
local utils = require('telescope.utils')
local themes = require('telescope.themes')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
-- local actions = require('telescope/actions')
-- local action_state = require('telescope/actions/state')
-- local sorters = require('telescope/sorters')
local conf = require('telescope.config').values

local filter = vim.tbl_filter

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

  local current_file = vim.fn.expand('%'):gsub("\\","/")
  local bufer_files = {}
  for _, bufnr in ipairs(bufnrs) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local file = vim.fn.fnamemodify(bufname, ':.'):gsub("\\","/")
    table.insert(bufer_files, file)
  end
  local git_files = utils.get_os_command_output({ 'git', 'ls-files', '--exclude-standard', '--cached', '--others' })

  local fusedArray = {}
  local n=0
  for _,v in ipairs(bufer_files) do n=n+1 ; fusedArray[n] = v end
  -- for _,v in ipairs(git_files) do n=n+1 ; fusedArray[n] = v end
  for _,v in ipairs(filter(function(v) return v ~= current_file end, git_files)) do n=n+1 ; fusedArray[n] = v end

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

return M
