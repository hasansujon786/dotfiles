local actions = require('telescope.actions')
local local_action = require('hasan.telescope.local_action')

require('telescope').setup{
  defaults = {
    file_sorter = require'telescope.sorters'.get_fzy_sorter,
    generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
    prompt_prefix = '  ',
    selection_caret = ' ',
    layout_config = {
      height = 0.7,
      width = 0.8,
    },
    -- prompt_position = "top",
    -- sorting_strategy = "ascending",
    winblend = 5,
    mappings = {
      -- n = {
      --   ["<Del>"] = actions.close
      -- },
      i = {
        ["<C-x>"] = false,
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-s>"] = actions.file_split,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
        ["<M-u>"] = actions.preview_scrolling_up,
        ["<M-d>"] = actions.preview_scrolling_down,
        ["<C-f>"] = local_action.fedit,
      },
    },
    file_ignore_patterns = { "%.gitignore" },
    -- `file_ignore_patterns = { "scratch/.*", "%.env" }`
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    }
  }
}
require('telescope').load_extension('fzy_native')

