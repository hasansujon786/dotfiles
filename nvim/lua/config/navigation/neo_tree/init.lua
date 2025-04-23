local util = require('config.navigation.neo_tree.util')

return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  -- event = 'CursorHold',
  cmd = { 'Neotree' },
  branch = 'v3.x',
  vinegar_helper = util,
  keys = {
    {
      '<leader>op',
      '<cmd>lua require("config.navigation.neo_tree.util").toggle_neotree()<CR><C-l>',
      desc = 'NeoTree: Toggle sidebar',
    },
    { '-', '<cmd>lua require("config.navigation.neo_tree.util").open_vinegar()<CR>', desc = 'NeoTree: Open vinegar' },
    { '<leader>oj', '<cmd>lua require("config.navigation.neo_tree.util").open_vinegar()<CR>', desc = 'NeoTree: Open vinegar' },
  },
  config = function()
    keymap('n', '<bs>', '<cmd>lua require("config.navigation.neo_tree.util").edit_alternate_file()<CR>', { desc = 'Edit alternate file' })

    ---@module "neo-tree"
    ---@type neotree.Config
    local opts = {
      -- see `:h neo-tree-custom-commands-global`
      -- A list of functions, each representing a global custom command
      -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
      -- commands = {},
      -- nesting_rules = {},
      source_selector = require('config.navigation.neo_tree.other').source_selector,
      event_handlers = require('config.navigation.neo_tree.other').event_handlers,
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = { '', '█', '', '▕', '', '▔', '', '▏' },
      enable_git_status = true,
      enable_diagnostics = false,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- when opening files, do not use windows containing these filetypes or buftypes
      sort_case_insensitive = false, -- used when sorting files and directories in the tree
      sort_function = nil, -- use a custom function for sorting files and directories in the tree
      default_component_configs = require('config.navigation.neo_tree.default_component_configs'),
      window = require('config.navigation.neo_tree.window'),
      filesystem = require('config.navigation.neo_tree.filesystem'),
      buffers = require('config.navigation.neo_tree.buffers'),
      git_status = require('config.navigation.neo_tree.git_status'),
    }

    require('neo-tree').setup(opts)
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
}
