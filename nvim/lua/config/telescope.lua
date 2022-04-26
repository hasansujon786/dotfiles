local actions = require('telescope.actions')
local local_action = require('hasan.telescope.local_action')

require('telescope').setup({
  defaults = {
    scroll_strategy = 'cycle',
    selection_strategy = 'reset',
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    -- prompt_prefix = '  ',
    prompt_prefix = '  ',
    selection_caret = '❯ ',
    layout_config = {
      height = 0.7,
      width = 0.8,
    },
    -- prompt_position = "top",
    -- sorting_strategy = "ascending",
    winblend = 0,
    mappings = {
      n = {
        ['<M-p>'] = actions.move_selection_previous,
        ['<M-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['<C-n>'] = actions.move_selection_next,
      },
      i = {
        ['<M-p>'] = actions.move_selection_previous,
        ['<M-n>'] = actions.move_selection_next,
        ['<C-s>'] = actions.file_split,
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<esc>'] = actions.close,
        ['<M-u>'] = actions.preview_scrolling_up,
        ['<M-d>'] = actions.preview_scrolling_down,
        ['<C-x>'] = false,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-f>'] = local_action.fedit,
      },
    },
    -- `file_ignore_patterns = { "scratch/.*", "%.env" }`
    file_ignore_patterns = {
      '%.gitignore',
      '%.git/.*',
      '4_archive/.*',
      '%.bin/.*',
      '%.bin%-win/.*',
      '%.system/.*',
      'android/.*',
      'ios/.*',
      'pubspec.lock',
    },
  },
  pickers = {
    lsp_document_symbols = {
      theme = 'dropdown',
      previewer = false,
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = true,
      override_file_sorter = true,
    },
    ['ui-select'] = {
      require('telescope.themes').get_cursor({
        attach_mappings = function(_, map)
          map('i', '<tab>', actions.move_selection_next)
          map('n', '<tab>', actions.move_selection_next)
          map('i', '<S-tab>', actions.move_selection_previous)
          map('n', '<S-tab>', actions.move_selection_previous)
          return true
        end,
      }),
    },
  },
})

require('telescope').load_extension('fzy_native')
require('telescope').load_extension('ui-select')
