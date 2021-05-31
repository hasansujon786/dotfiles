
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

