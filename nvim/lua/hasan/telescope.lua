-- telescope
-- local actions = require('telescope/actions')
local utils = require('telescope.utils')
-- local pickers = require('telescope.pickers')
-- local finders = require('telescope.finders')
-- local make_entry = require('telescope.make_entry')

-- local conf = require('telescope.config').values

require('telescope').setup{
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    prompt_prefix = '❯ ',
    selection_caret = '❯ ',
    -- prompt_position = "top",
    -- sorting_strategy = "ascending",
    -- mappings = {
    --   n = {
    --     ["<Del>"] = actions.close
    --   },
    --   i = {
    --     ["<C-x>"] = false,
    --     ["<C-q>"] = actions.send_to_qflist,
    --   },
    -- },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    }
  }
}
require('telescope').load_extension('fzy_native')

local M = {}

M.project_files = function()
  local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
  local gopts = {}
  gopts.prompt_title = 'Git Files'
  gopts.prompt_prefix = '  '
  if ret == 0 then
    require('telescope.builtin').git_files(gopts)
  else
   require('telescope.builtin').find_files()
  end
end



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
