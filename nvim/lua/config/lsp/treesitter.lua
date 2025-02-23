return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'TSUpdate', 'TSUpdateSync', 'TSInstall', 'TSInstallSync' },
    keys = {
      { '<leader>vI', '<Cmd>lua require("noice").redirect("Inspect")<CR>', desc = 'Show ts highlight' },
    },
    config = function()
      -- TSInstallSync javascript typescript tsx
      local parsers = {
        'bash',
        'gitcommit',
        'css',
        'dart',
        'html',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'regex',
        'vim',
        'vimdoc',
        'vue',
        'javascript',
        'typescript',
        'tsx',
      }

      require('nvim-treesitter.configs').setup({
        ensure_installed = parsers,
        highlight = {
          enable = true, -- false will disable the whole extension
          use_languagetree = false,
          disable = { 'vim' },
          additional_vim_regex_highlighting = { 'vim', 'markdown' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'g<tab>', -- maps in normal mode to init the node/scope selection
            scope_incremental = 'O', -- increment to the upper scope (as defined in locals.scm)
            node_incremental = '<tab>', -- increment to the upper named parent
            node_decremental = '<s-tab>', -- decrement to the previous node
          },
        },
        indent = { enable = true, disable = { 'dart' } },
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['i='] = { query = '@assignment.rhs', desc = 'assignment rhs' },
              ['a='] = { query = '@assignment.outer', desc = 'assignment' },
              ['iv'] = { query = '@assignment.lhs', desc = 'assignment lhs' },
              ['av'] = { query = '@assignment.outer', desc = 'assignment' },
              ['if'] = { query = '@function.inner', desc = 'inner function' },
              ['af'] = { query = '@function.outer', desc = 'function' },
              ['ic'] = { query = '@call.inner', desc = 'inner function call' },
              ['ac'] = { query = '@call.outer', desc = 'function call' },
              ['im'] = { query = '@class.inner', desc = 'inner class' },
              ['am'] = { query = '@class.outer', desc = 'class' },
              ['ik'] = { query = '@pair.inner', desc = 'inner pair' },
              ['ak'] = { query = '@pair.outer', desc = 'pair' }, -- object's { key: value }
              ['io'] = { query = '@block.inner', desc = 'inner block' },
              ['ao'] = { query = '@block.outer', desc = 'block' },
              ['i/'] = { query = '@comment.inner', desc = 'inner comment' },
              ['a/'] = { query = '@comment.outer', desc = 'comment' },
              ['iC'] = { query = '@conditional.inner', desc = 'inner conditional' },
              ['aC'] = { query = '@conditional.outer', desc = 'conditional' },
              ['iP'] = { query = '@parameter.inner', desc = 'inner parameter' },
              ['aP'] = { query = '@parameter.outer', desc = 'parameter' },
              ['iR'] = { query = '@return.inner', desc = 'inner return' },
              ['aR'] = { query = '@return.outer', desc = 'return' },
              -- ['ii'] = { query = '@indent.begin', query_group = 'indents', desc = 'inner indent begin' },
              -- ['ai'] = { query = '@fold', query_group = 'folds', desc = 'fold' },
              -- ['ii'] = { query = '@local.scope', desc = 'Select language scope' },
              -- @loop.inner
              -- @loop.outer
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<Plug>(ts-swap-parameter-next)'] = '@parameter.inner',
            },
            swap_previous = {
              ['<Plug>(ts-swap-parameter-prev)'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = false, -- whether to set jumps in the jumplist
            goto_next_start = {
              ['<Plug>(ts-jump-next-s-func)'] = '@function.outer',
              ['<Plug>(ts-jump-next-s-class)'] = '@class.outer',
            },
            goto_previous_start = {
              ['<Plug>(ts-jump-prev-s-func)'] = '@function.outer',
              ['<Plug>(ts-jump-prev-s-class)'] = '@class.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']M'] = '@class.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[M'] = '@class.outer',
            },
          },
          -- lsp_interop = {
          --   enable = true,
          --   border = 'double',
          --   peek_definition_code = {
          --     ["df"] = "@function.outer",
          --     ["dF"] = "@class.outer",
          --   },
          -- }
        },
      })

      -- stylua: ignore start
      keymap('n', '<P', '<Plug>(ts-swap-parameter-prev)<cmd>call repeat#set("\\<Plug>(ts-swap-parameter-prev)")<CR>', { desc = 'Swap parameter prev' })
      keymap('n', '>P', '<Plug>(ts-swap-parameter-next)<cmd>call repeat#set("\\<Plug>(ts-swap-parameter-next)")<CR>', { desc = 'Swap parameter next' })
      -- stylua: ignore end
      keymap('n', '[f', '<Plug>(ts-jump-prev-s-func)zz', { desc = 'Jump prev func' })
      keymap('n', ']f', '<Plug>(ts-jump-next-s-func)zz', { desc = 'Jump next func' })
      keymap('n', '[m', '<Plug>(ts-jump-prev-s-class)zz', { desc = 'Jump prev class' })
      keymap('n', ']m', '<Plug>(ts-jump-next-s-class)zz', { desc = 'Jump next class' })
    end,
    dependencies = {
      -- 'nvim-treesitter/nvim-treesitter-textobjects',
      { 'hasansujon786/nvim-treesitter-textobjects', dev = false },
      {
        'windwp/nvim-ts-autotag',
        opts = {
          opts = {
            enable_close = true, -- Auto close tags
            enable_rename = true, -- Auto rename pairs of tags
            enable_close_on_slash = false, -- Auto close on trailing </
          },
        },
      },
      {
        'catgoose/nvim-colorizer.lua',
        opts = {
          filetypes = {
            '*', -- Highlight all files, but customize some others.
            dart = { AARRGGBB = true, names = false },
            css = { css = true },
          },
          user_default_options = {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            rgb_fn = true, -- CSS rgb() and rgba() functions
            hsl_fn = true, -- CSS hsl() and hsla() functions
            names = false, -- "Name" codes like Blue or blue
            RRGGBBAA = false, -- #RRGGBBAA hex codes
            AARRGGBB = false, -- 0xAARRGGBB hex codes
            css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            mode = 'background', -- Set the display mode. 'foreground', 'background', 'virtualtext'
            virtualtext = '■',
            tailwind = 'lsp', -- Available methods are false / true / "normal" / "lsp" / "both" | True is same as normal
          },
          buftypes = { '!prompt', '!popup' },
        },
      },
    },
  },
  {
    'tpope/vim-commentary',
    lazy = true,
    event = 'BufReadPost',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    commit = '2bcf700', -- 8fd989b
    enabled = true,
    lazy = true,
    event = 'CursorHold',
    keys = {
      {
        'g{',
        function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end,
        mode = '',
        desc = 'Move cursor to context',
      },
    },
    opts = function()
      local tsc = require('treesitter-context')
      Snacks.toggle({
        name = 'TSContext',
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map('<leader>t.')

      return {
        enable = require('core.state').treesitter.enabled_context, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },
}
