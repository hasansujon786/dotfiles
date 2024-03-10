local util = require('config.neo_tree.util')
-- lua require("neo-tree").paste_default_config()

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
      function()
        vim.g.cwd = vim.loop.cwd()
        require('hasan.nebulous').mark_as_alternate_win()
        local readonly = vim.api.nvim_buf_get_option(0, 'readonly')
        local modifiable = vim.api.nvim_buf_get_option(0, 'modifiable')
        local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

        if filetype == 'neo-tree' then
          vim.cmd([[Neotree close]])
        elseif readonly or not modifiable then
          vim.cmd([[Neotree filesystem left]])
        else
          vim.cmd([[Neotree filesystem left reveal_file=%:p]])
        end
      end,
      desc = 'NeoTree: Toggle sidebar',
    },
    {
      '-',
      function()
        util.open_vinegar()
      end,
      desc = 'NeoTree: Open vinegar',
    },
  },
  config = function()
    keymap('n', '<bs>', util.edit_alternate_file, { desc = 'Edit alternate file' })

    local opts = {
      -- see `:h neo-tree-custom-commands-global`
      -- A list of functions, each representing a global custom command
      -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
      -- commands = {},
      -- nesting_rules = {},
      source_selector = require('config.neo_tree.other').source_selector,
      event_handlers = require('config.neo_tree.other').event_handlers,
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = require('core.state').ui.hover.border,
      enable_git_status = true,
      enable_diagnostics = false,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- when opening files, do not use windows containing these filetypes or buftypes
      sort_case_insensitive = false, -- used when sorting files and directories in the tree
      sort_function = nil, -- use a custom function for sorting files and directories in the tree
      default_component_configs = require('config.neo_tree.default_component_configs'),
      window = require('config.neo_tree.window'),
      filesystem = require('config.neo_tree.filesystem'),
      buffers = require('config.neo_tree.buffers'),
      git_status = require('config.neo_tree.git_status'),
    }

    require('neo-tree').setup(opts)
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
}
