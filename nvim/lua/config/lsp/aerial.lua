return {
  'stevearc/aerial.nvim',
  keys = {
    { '<leader>oo', '<cmd>AerialOpen<CR>' },
    -- { 'zo', '<cmd>AerialNavOpen<CR>' },
  },
  dependencies = { 'folke/edgy.nvim' },
  config = function()
    -- Call the setup function to change the default behavior
    require('aerial').setup({
      -- Priority list of preferred backends for aerial.
      -- This can be a filetype map (see :help aerial-filetype-map)
      backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },
      layout = {
        max_width = 31,
        width = 31,
        min_width = 31,
        win_opts = {},
        default_direction = 'prefer_left',
        resize_to_content = false,
        preserve_equality = false,
      },
      keymaps = {
        ['n'] = 'actions.down_and_scroll',
        ['p'] = 'actions.up_and_scroll',
        ['o'] = 'actions.jump',
        ['<tab>'] = 'actions.tree_toggle',
        ['i'] = 'actions.scroll',
      },
      lazy_load = true,
      disable_max_lines = 10000,
      disable_max_size = 2000000, -- Default (in bytes) 2MB
      -- A list of all symbols to display. Set to false to display all symbols.
      -- This can be a filetype map (see :help aerial-filetype-map)
      -- To see all available values, see :help SymbolKind
      filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
        -- 'Variable',
        -- 'Constant',
      },

      -- Determines line highlighting mode when multiple splits are visible.
      -- split_width   Each open window will have its cursor location marked in the
      --               aerial buffer. Each line will only be partially highlighted
      --               to indicate which window is at that location.
      -- full_width    Each open window will have its cursor location marked as a
      --               full-width highlight in the aerial buffer.
      -- last          Only the most-recently focused window will have its location
      --               marked in the aerial buffer.
      -- none          Do not show the cursor locations in the aerial window.
      highlight_mode = 'split_width',

      -- Highlight the closest symbol if the cursor is not exactly on one.
      highlight_closest = true,

      -- Highlight the symbol in the source buffer when cursor is in the aerial win
      highlight_on_hover = false,

      -- When jumping to a symbol, highlight the line for this many ms.
      -- Set to false to disable
      highlight_on_jump = 300,

      -- Jump to symbol in source window when the cursor moves
      autojump = false,

      -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
      -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
      -- default collapsed icon. The default icon set is determined by the
      -- "nerd_font" option below.
      -- If you have lspkind-nvim installed, it will be the default icon set.
      -- This can be a filetype map (see :help aerial-filetype-map)
      icons = {},

      -- Control which windows and buffers aerial should ignore.
      -- Aerial will not open when these are focused, and existing aerial windows will not be updated
      ignore = {
        -- Ignore unlisted buffers. See :help buflisted
        unlisted_buffers = false,

        -- Ignore diff windows (setting to false will allow aerial in diff windows)
        diff_windows = true,

        -- List of filetypes to ignore.
        filetypes = {},

        -- Ignored buftypes.
        -- Can be one of the following:
        -- false or nil - No buftypes are ignored.
        -- "special"    - All buffers other than normal, help and man page buffers are ignored.
        -- table        - A list of buftypes to ignore. See :help buftype for the
        --                possible values.
        -- function     - A function that returns true if the buffer should be
        --                ignored or false if it should not be ignored.
        --                Takes two arguments, `bufnr` and `buftype`.
        buftypes = 'special',

        -- Ignored wintypes.
        -- Can be one of the following:
        -- false or nil - No wintypes are ignored.
        -- "special"    - All windows other than normal windows are ignored.
        -- table        - A list of wintypes to ignore. See :help win_gettype() for the
        --                possible values.
        -- function     - A function that returns true if the window should be
        --                ignored or false if it should not be ignored.
        --                Takes two arguments, `winid` and `wintype`.
        wintypes = 'special',
      },

      -- Use symbol tree for folding. Set to true or false to enable/disable
      -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
      -- This can be a filetype map (see :help aerial-filetype-map)
      manage_folds = false,

      -- When you fold code with za, zo, or zc, update the aerial tree as well.
      -- Only works when manage_folds = true
      link_folds_to_tree = false,

      -- Fold code when you open/collapse symbols in the tree.
      -- Only works when manage_folds = true
      link_tree_to_folds = true,

      -- Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/)
      -- "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed.
      nerd_font = 'auto',

      -- Call this function when aerial attaches to a buffer.
      on_attach = function(bufnr) end,

      -- Call this function when aerial first sets symbols on a buffer.
      on_first_symbols = function(bufnr) end,

      -- Automatically open aerial when entering supported buffers.
      -- This can be a function (see :help aerial-open-automatic)
      open_automatic = false,

      -- Run this command after jumping to a symbol (false will disable)
      post_jump_cmd = 'normal! zz',

      -- Invoked after each symbol is parsed, can be used to modify the parsed item,
      -- or to filter it by returning false.
      --
      -- bufnr: a neovim buffer number
      -- item: of type aerial.Symbol
      -- ctx: a record containing the following fields:
      --   * backend_name: treesitter, lsp, man...
      --   * lang: info about the language
      --   * symbols?: specific to the lsp backend
      --   * symbol?: specific to the lsp backend
      --   * syntax_tree?: specific to the treesitter backend
      --   * match?: specific to the treesitter backend, TS query match
      post_parse_symbol = function(bufnr, item, ctx)
        return true
      end,

      -- Invoked after all symbols have been parsed and post-processed,
      -- allows to modify the symbol structure before final display
      --
      -- bufnr: a neovim buffer number
      -- items: a collection of aerial.Symbol items, organized in a tree,
      --        with 'parent' and 'children' fields
      -- ctx: a record containing the following fields:
      --   * backend_name: treesitter, lsp, man...
      --   * lang: info about the language
      --   * symbols?: specific to the lsp backend
      --   * syntax_tree?: specific to the treesitter backend
      post_add_all_symbols = function(bufnr, items, ctx)
        return items
      end,

      -- When true, aerial will automatically close after jumping to a symbol
      close_on_select = false,

      -- The autocmds that trigger symbols update (not used for LSP backend)
      update_events = 'TextChanged,InsertLeave',

      -- Show box drawing characters for the tree hierarchy
      show_guides = false,

      -- Customize the characters used when show_guides = true
      guides = {
        -- When the child item has a sibling below it
        mid_item = '├─',
        -- When the child item is the last in the list
        last_item = '└─',
        -- When there are nested child guides to the right
        nested_top = '│ ',
        -- Raw indentation
        whitespace = '  ',
      },

      -- Set this function to override the highlight groups for certain symbols
      get_highlight = function(symbol, is_icon, is_collapsed)
        -- return "MyHighlight" .. symbol.kind
      end,

      -- Options for opening aerial in a floating win
      float = {
        -- Controls border appearance. Passed to nvim_open_win
        border = 'rounded',

        -- Determines location of floating window
        --   cursor - Opens float on top of the cursor
        --   editor - Opens float centered in the editor
        --   win    - Opens float centered in the window
        relative = 'cursor',

        -- These control the height of the floating window.
        -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a list of mixed types.
        -- min_height = {8, 0.1} means "the greater of 8 rows or 10% of total"
        max_height = 0.9,
        height = nil,
        min_height = { 8, 0.1 },

        override = function(conf, source_winid)
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          return conf
        end,
      },

      -- Options for the floating nav windows
      nav = {
        border = 'single',
        max_height = 0.9,
        min_height = { 10, 0.1 },
        max_width = 0.5,
        min_width = { 0.2, 20 },
        win_opts = {
          cursorline = true,
          winblend = 10,
        },
        -- Jump to symbol in source window when the cursor moves
        autojump = false,
        -- Show a preview of the code in the right column, when there are no child symbols
        preview = false,
        -- Keymaps in the nav window
        keymaps = {
          ['o'] = 'actions.jump',
          ['q'] = 'actions.close',
        },
      },

      lsp = {
        -- If true, fetch document symbols when LSP diagnostics update.
        diagnostics_trigger_update = false,

        -- Set to false to not update the symbols when there are LSP errors
        update_when_errors = true,

        -- How long to wait (in ms) after a buffer change before updating
        -- Only used when diagnostics_trigger_update = false
        update_delay = 300,

        -- Map of LSP client name to priority. Default value is 10.
        -- Clients with higher (larger) priority will be used before those with lower priority.
        -- Set to -1 to never use the client.
        priority = {
          -- pyright = 10,
        },
      },
    })
  end,
}
