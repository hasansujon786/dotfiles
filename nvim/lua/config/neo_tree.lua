local function vinegar_dir_up(state)
  local Path = require('plenary.path')
  -- local node = state.tree:get_node()
  -- P(node.is_last_child)

  local cur_dir = state.path
  local parent_dir = Path:new(cur_dir):parent()
  require('neo-tree.sources.filesystem').navigate(state, parent_dir.filename, cur_dir)
end

-- if vim.fn.filereadable(path) == 0 then
return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  -- event = 'CursorHold',
  branch = 'v3.x',
  keys = {
    {
      '<leader>op',
      function()
        vim.g.cwd = vim.loop.cwd()
        -- vim.cmd('Neotree filesystem left reveal_file=%:p')
        vim.cmd('Neotree filesystem left')
      end,
      desc = 'NeoTree: Open sidebar',
    },
    {
      '-',
      function()
        vim.g.cwd = vim.loop.cwd()
        vim.cmd('Neotree position=current dir=%:p:h reveal_file=%:p')
      end,
      desc = 'NeoTree: Open vinegar',
    },
  },
  config = function(_, opts)
    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    -- vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    -- vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
    -- vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
    -- vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

    require('neo-tree').setup(opts)
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- when opening files, do not use windows containing these filetypes or buftypes
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil, -- use a custom function for sorting files and directories in the tree
    -- sort_function = function (a,b)
    --       if a.type == b.type then
    --           return a.path > b.path
    --       else
    --           return a.type > b.type
    --       end
    --   end , -- this sorts files and directories descendantly
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 1,
        padding = 1, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        highlight = 'NeoTreeIndentMarker',
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '󰜌',
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = '*',
        highlight = 'NeoTreeFileIcon',
      },
      modified = {
        symbol = '[+]',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '󰁕', -- this can only be used in the git_status source
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
      -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
      file_size = { enabled = false, required_width = 64 },
      type = { enabled = false, required_width = 122 },
      last_modified = { enabled = false, required_width = 88 },
      created = { enabled = false, required_width = 110 },
      symlink_target = { enabled = false },
    },
    -- A list of functions, each representing a global custom command
    -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
    -- see `:h neo-tree-custom-commands-global`
    commands = {},
    window = {
      position = 'left',
      width = 40,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['<space>'] = {
          'toggle_node',
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ['<cr>'] = 'open',
        ['<2-LeftMouse>'] = 'open',
        ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
        ['P'] = { 'toggle_preview', config = { use_float = true } },
        ['l'] = 'focus_preview',
        ['s'] = 'open_split',
        ['v'] = 'open_vsplit',
        -- ["S"] = "split_with_window_picker",
        -- ["s"] = "vsplit_with_window_picker",
        ['t'] = 'open_tabnew',
        -- ["<cr>"] = "open_drop",
        -- ["t"] = "open_tab_drop",
        ['w'] = 'open_with_window_picker',
        --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
        ['C'] = 'close_node',
        -- ['C'] = 'close_all_subnodes',
        ['z'] = 'close_all_nodes',
        --["Z"] = "expand_all_nodes",
        ['a'] = {
          'add',
          -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = 'none', -- "none", "relative", "absolute"
          },
        },
        ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
        -- ["c"] = {
        --  "copy",
        --  config = {
        --    show_path = "none" -- "none", "relative", "absolute"
        --  }
        --}
        ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
        ['q'] = 'close_window',
        ['R'] = 'refresh',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
        ['i'] = 'show_file_details',
      },
    },
    nesting_rules = {},
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          --"node_modules"
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = false, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",  -- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
      window = {
        mappings = {
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          ['-'] = function(state)
            vinegar_dir_up(state)
          end,
          ['h'] = function(state)
            vinegar_dir_up(state)

            -- local node = state.tree:get_node()
            -- if node.type == 'directory' and node:is_expanded() then
            --   require('neo-tree.sources.filesystem').toggle_directory(state, node)
            -- else
            --   require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
            -- end
          end,
          ['l'] = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' then
              state.commands['set_root'](state)
              vim.defer_fn(function()
                feedkeys('j')
              end, 80)

              -- if not node:is_expanded() then
              --   require('neo-tree.sources.filesystem').toggle_directory(state, node)
              -- elseif node:has_children() then
              --   require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
              -- end
            else
              state.commands['open'](state)
            end
          end,
          ['W'] = function(state)
            state.commands['close_all_nodes'](state)
            if state.path ~= vim.g.cwd then
              require('neo-tree.sources.filesystem').navigate(state, vim.g.cwd)
            end
            feedkeys('ggj')
          end,
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['D'] = 'fuzzy_finder_directory',
          ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ['f'] = 'filter_on_submit',
          ['<c-x>'] = 'clear_filter',
          ['[c'] = 'prev_git_modified',
          [']c'] = 'next_git_modified',
          -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          -- ['oc'] = { 'order_by_created', nowait = false },
          -- ['od'] = { 'order_by_diagnostics', nowait = false },
          -- ['og'] = { 'order_by_git_status', nowait = false },
          -- ['om'] = { 'order_by_modified', nowait = false },
          -- ['on'] = { 'order_by_name', nowait = false },
          -- ['os'] = { 'order_by_size', nowait = false },
          -- ['ot'] = { 'order_by_type', nowait = false },
          ['o'] = 'open',
          ['oc'] = 'none',
          ['od'] = 'none',
          ['og'] = 'none',
          ['om'] = 'none',
          ['on'] = 'none',
          ['os'] = 'none',
          ['ot'] = 'none',
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ['<down>'] = 'move_cursor_down',
          ['<C-n>'] = 'move_cursor_down',
          ['<up>'] = 'move_cursor_up',
          ['<C-p>'] = 'move_cursor_up',
        },
      },

      commands = {}, -- Add a custom command or override a global one using the same function name
    },
    buffers = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --              -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ['bd'] = 'buffer_delete',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          -- ['oc'] = { 'order_by_created', nowait = false },
          -- ['od'] = { 'order_by_diagnostics', nowait = false },
          -- ['om'] = { 'order_by_modified', nowait = false },
          -- ['on'] = { 'order_by_name', nowait = false },
          -- ['os'] = { 'order_by_size', nowait = false },
          -- ['ot'] = { 'order_by_type', nowait = false },
          ['o'] = 'none',
          ['oc'] = 'none',
          ['od'] = 'none',
          ['om'] = 'none',
          ['on'] = 'none',
          ['os'] = 'none',
          ['ot'] = 'none',
        },
      },
    },
    git_status = {
      window = {
        position = 'float',
        mappings = {
          ['A'] = 'git_add_all',
          ['gu'] = 'git_unstage_file',
          ['ga'] = 'git_add_file',
          ['gr'] = 'git_revert_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          ['gg'] = 'git_commit_and_push',
          -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          -- ['oc'] = { 'order_by_created', nowait = false },
          -- ['od'] = { 'order_by_diagnostics', nowait = false },
          -- ['om'] = { 'order_by_modified', nowait = false },
          -- ['on'] = { 'order_by_name', nowait = false },
          -- ['os'] = { 'order_by_size', nowait = false },
          -- ['ot'] = { 'order_by_type', nowait = false },
          ['o'] = 'none',
          ['oc'] = 'none',
          ['od'] = 'none',
          ['om'] = 'none',
          ['on'] = 'none',
          ['os'] = 'none',
          ['ot'] = 'none',
        },
      },
    },
  },
}