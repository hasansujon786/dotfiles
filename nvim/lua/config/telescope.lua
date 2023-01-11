local actions = require('telescope.actions')
local local_action = require('hasan.telescope.local_action')

local custom_mappings = {
  ['<C-p>'] = actions.move_selection_previous,
  ['<C-n>'] = actions.move_selection_next,
  ['<M-p>'] = actions.move_selection_previous,
  ['<M-n>'] = actions.move_selection_next,
  ['<C-s>'] = actions.file_split,
  ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
  ['<esc>'] = actions.close,
  ['<M-u>'] = actions.preview_scrolling_up,
  ['<M-d>'] = actions.preview_scrolling_down,
  ['<C-f>'] = local_action.fedit,
  ['<C-x>'] = false,
  ['<C-u>'] = false,
  ['<C-d>'] = false,
}

require('telescope').setup({
  defaults = {
    scroll_strategy = 'cycle',
    selection_strategy = 'reset',
    prompt_prefix = '  ',
    selection_caret = '❯ ',
    layout_config = {
      height = 0.7,
      width = 0.8,
    },
    -- prompt_position = "top",
    -- sorting_strategy = "ascending",
    winblend = 0,
    mappings = { n = custom_mappings, i = custom_mappings },
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
    find_files = { theme = 'ivy', layout_config = { height = 0.7 } },
    lsp_document_symbols = { theme = 'dropdown' },
    lsp_references = { theme = 'dropdown' },
    grep_string = { theme = 'dropdown' },
    live_grep = { theme = 'dropdown' },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true,
      override_file_sorter = true,
    },
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    project_commands = require('config.project_commands'),
  },
})
require('telescope').load_extension('fzf')
