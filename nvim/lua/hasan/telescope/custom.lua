-- local actions = require('telescope/actions')
local builtin = require('telescope.builtin')
local utils = require('telescope.utils')
local themes = require('telescope.themes')
-- local pickers = require('telescope.pickers')
-- local finders = require('telescope.finders')
-- local make_entry = require('telescope.make_entry')

-- local conf = require('telescope.config').values

local M = {}

M.project_files = function()
  local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
  local gopts = {
    prompt_title = 'Git Files',
    prompt_prefix = '  '
  }
  if ret == 0 then
    builtin.git_files(gopts)
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
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }
  builtin.current_buffer_fuzzy_find(opts)
end


function M.search_wiki_files()
  builtin.find_files({
      prompt_title = "Wiki Files",
      cwd = "~/vimwiki",
    })
end

function M.search_plugins()
  builtin.find_files({
      prompt_title = "Plugins",
      cwd = "~/dotfiles/nvim/plugged/",
    })
end
-- lua require("hasan.telescope.custom").search_plugins()



-- M.custom = function (opts)
--   require('telescope.builtin').find_files({
--       finder = finders.new_table {
--         results = {
--           "~/dotfiles/nvim/init.vim",
--           "path/to/another_file"
--         },

--         entry_maker = opts.entry_maker,
--       },
--     })
--   pickers.new(opts, {
--       prompt_title = 'ConfigPicker',
--       finder = finders.new_table {
--         results = {
--           "path/to/file",
--           "path/to/another_file"
--         },

--         entry_maker = opts.entry_maker,
--       },
--     }):find()
-- end



return M
