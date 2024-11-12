return {
  'oskarrrrrrr/symbols.nvim',
  enabled = true,
  keys = {
    { '<leader>oo', '<cmd>Symbols<CR>' },
    -- { 'zo', '<cmd>AerialNavOpen<CR>' },
  },
  dependencies = { 'folke/edgy.nvim' },
  config = function()
    local r = require('symbols.recipes')
    require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
      sidebar = {
        hide_cursor = true, -- Hide the cursor when in sidebar.
        open_direction = 'try-left',
        on_open_make_windows_equal = false, -- Whether to run `wincmd =` after opening a sidebar.
        cursor_follow = true,
        auto_resize = {
          enabled = false,
          min_width = 20,
          max_width = 40,
        },
        fixed_width = 31,
        -- Allows to filter symbols. By default all the symbols are shown.
        symbol_filter = function(filetype, symbol)
          return true
        end,
        -- Show details floating window at all times.
        show_details_pop_up = false,
        wrap = false, -- Whether the sidebar should wrap text.
        -- Whether to show the guide lines.
        show_guide_lines = false,
        chars = {
          folded = '',
          unfolded = '',
          guide_vert = '│',
          guide_middle_item = '├',
          guide_last_item = '└',
        },
        -- Config for the preview window.
        preview = {
          -- Whether the preview window is always opened when the sidebar is
          -- focused.
          show_always = false,
          -- Whether the preview window should show line numbers.
          show_line_number = false,
          -- Whether to determine the preview window's height automatically.
          auto_size = true,
          -- The total number of extra lines shown in the preview window.
          auto_size_extra_lines = 6,
          -- Minimum window height when `auto_size` is true.
          min_window_height = 7,
          -- Maximum window height when `auto_size` is true.
          max_window_height = 30,
          -- Preview window size when `auto_size` is false.
          fixed_size_height = 12,
          -- Desired preview window width. Actuall width will be capped at
          -- the current width of the source window width.
          window_width = 100,
          -- Keymaps for actions in the preview window. Available actions:
          -- close: Closes the preview window.
          -- goto-code: Changes window to the source code and moves cursor to
          --            the same position as in the preview window.
          -- Note: goto-code is not set by default because the most natual
          -- key would be Enter but some people already have that key mapped.
          keymaps = {
            ['q'] = 'close',
          },
        },
        -- Keymaps for actions in the sidebar. All available actions are used
        -- in the default keymaps.
        keymaps = {
          -- Jumps to symbol in the source window.
          ['<CR>'] = 'goto-symbol',
          ['o'] = 'goto-symbol',
          -- sidebar.
          ['<RightMouse>'] = 'peek-symbol',
          ['i'] = 'peek-symbol',

          ['K'] = 'open-details-window',
          ['P'] = 'open-preview',

          -- In the sidebar jumps to symbol under the cursor in the source
          -- window. Unfolds all the symbols on the way.
          ['gs'] = 'show-symbol-under-cursor',
          -- Jumps to parent symbol. Can be used with a count, e.g. "3gp"
          -- will go 3 levels up.
          ['gp'] = 'goto-parent',
          -- Jumps to the previous symbol at the same nesting level.
          ['[['] = 'prev-symbol-at-level',
          -- Jumps to the next symbol at the same nesting level.
          [']]'] = 'next-symbol-at-level',

          -- Unfolds the symbol under the cursor.
          ['l'] = 'unfold',
          ['zo'] = 'unfold',
          -- Unfolds the symbol under the cursor and all its descendants.
          ['L'] = 'unfold-recursively',
          ['zO'] = 'unfold-recursively',
          -- Reduces folding by one level. Can be used with a count,
          -- e.g. "3zr" will unfold 3 levels.
          ['zr'] = 'unfold-one-level',
          -- Unfolds all symbols in the sidebar.
          ['zR'] = 'unfold-all',

          -- Folds the symbol under the cursor.
          ['h'] = 'fold',
          ['zc'] = 'fold',
          -- Folds the symbol under the cursor and all its descendants.
          ['H'] = 'fold-recursively',
          ['zC'] = 'fold-recursively',
          -- Increases folding by one level. Can be used with a count,
          -- e.g. "3zm" will fold 3 levels.
          ['zm'] = 'fold-one-level',
          -- Folds all symbols in the sidebar.
          ['zM'] = 'fold-all',

          -- Toggles inline details (see sidebar.show_inline_details).
          ['td'] = 'toggle-inline-details',
          -- Toggles auto details floating window (see sidebar.show_details_pop_up).
          ['tD'] = 'toggle-auto-details-window',
          -- Toggles auto preview floating window.
          ['tp'] = 'toggle-auto-preview',
          -- Toggles cursor hiding (see sidebar.auto_resize.
          ['tch'] = 'toggle-cursor-hiding',
          -- Toggles cursor following (see sidebar.cursor_follow).
          ['tcf'] = 'toggle-cursor-follow',
          -- Toggles symbol filters allowing the user to see all the symbols
          -- given by the provider.
          ['tf'] = 'toggle-filters',
          -- Toggles automatic peeking on cursor movement (see sidebar.auto_peek).
          ['to'] = 'toggle-auto-peek',

          -- Toggle fold of the symbol under the cursor.
          ['<2-LeftMouse>'] = 'toggle-fold',

          -- Close the sidebar window.
          ['q'] = 'close',

          -- Show help.
          ['?'] = 'help',
          ['g?'] = 'help',
        },
      },
      providers = {
        lsp = {
          timeout_ms = 1000,
          details = {},
          kinds = { default = {} },
          highlights = {
            default = {},
          },
        },
        treesitter = {
          details = {},
          kinds = { default = {} },
          highlights = {
            default = {},
          },
        },
      },
      dev = {
        enabled = false,
        log_level = vim.log.levels.ERROR,
        keymaps = {},
      },
    })
  end,
}
