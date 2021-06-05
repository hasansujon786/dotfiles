local actions = require('telescope/actions')

require('telescope').setup{
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    prompt_prefix = '❯ ',
    selection_caret = '❯ ',
    -- prompt_prefix = "  ",
    -- selection_caret = " ",
    -- prompt_position = "top",
    -- sorting_strategy = "ascending",
    mappings = {
      -- n = {
      --   ["<Del>"] = actions.close
      -- },
      i = {
        -- ["<C-q>"] = actions.send_to_qflist,
        ["<C-x>"] = false,
        ["<C-s>"] = actions.file_split,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
      },
    },
    -- file_ignore_patterns = { "parser.c" },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    }
  }
}
require('telescope').load_extension('fzy_native')

