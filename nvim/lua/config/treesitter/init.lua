return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'TSUpdate', 'TSUpdateSync', 'TSInstall', 'TSInstallSync' },
    keys = {
      { '<leader>vh', '<Cmd>lua require("noice").redirect("Inspect")<CR>', desc = 'Show ts highlight' },
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
              ['ic'] = '@call.inner',
              ['ac'] = '@call.outer',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['am'] = '@class.outer',
              ['im'] = '@class.inner',
              ['ak'] = '@pair.outer', -- local object
              ['ik'] = '@pair.inner',
              ['ao'] = '@block.outer',
              ['io'] = '@block.inner',
              ['a/'] = '@comment.outer',
              ['i/'] = '@comment.inner',
              ['iC'] = '@conditional.inner',
              ['aC'] = '@conditional.outer',
              ['iP'] = '@parameter.inner',
              ['aP'] = '@parameter.outer',
              -- ['a.'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
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
              [']['] = '@function.outer',
              [']M'] = '@class.outer',
            },
            goto_previous_end = {
              ['[]'] = '@function.outer',
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

      keymap('n', '<P', '<Plug>(ts-swap-parameter-prev):call repeat#set("\\<Plug>(ts-swap-parameter-prev)")<CR>')
      keymap('n', '>P', '<Plug>(ts-swap-parameter-next):call repeat#set("\\<Plug>(ts-swap-parameter-next)")<CR>')

      keymap('n', '[f', '<Plug>(ts-jump-prev-s-func)zz')
      keymap('n', ']f', '<Plug>(ts-jump-next-s-func)zz')
      keymap('n', '[[', '<Plug>(ts-jump-prev-s-func)zz')
      keymap('n', ']]', '<Plug>(ts-jump-next-s-func)zz')
      keymap('n', '[m', '<Plug>(ts-jump-prev-s-class)zz')
      keymap('n', ']m', '<Plug>(ts-jump-next-s-class)zz')

      _G.my_treesitter_foldexpr = function()
        vim.defer_fn(function()
          vim.wo.foldmethod = 'expr'
          if vim.b.treesitter_import_syntax ~= nil then
            vim.wo.foldexpr = string.format("v:lnum==1?'>1':getline(v:lnum)=~'%s'?1:nvim_treesitter#foldexpr()", vim.b.treesitter_import_syntax)
          else
            vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
          end
        end, 50)
      end

      local treesitter_foldtext_filetypes = 'html,css,javascript,typescript,tsx,typescriptreact,json,lua,vue,dart'
      local import_pattern = 'javascript,typescript,tsx,typescriptreact,vue,dart'
      augroup('MY_TREESITTER_AUGROUP')(function(autocmd)
        autocmd('FileType', 'lua my_treesitter_foldexpr()', { pattern = treesitter_foldtext_filetypes })
        autocmd('FileType', 'let b:treesitter_import_syntax = "import"', { pattern = import_pattern })
      end)
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
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
        'NvChad/nvim-colorizer.lua',
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
    'ziontee113/neo-minimap',
    lazy = true,
    keys = {
      { 'zo', desc = 'Open minimap' },
      { 'zi', desc = 'Open minimap' },
      { 'zu', desc = 'Open minimap' },
    },
    config = function()
      require('config.treesitter.neo_minimap')
    end,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    event = 'BufReadPost',
    config = function()
      require('ts_context_commentstring').setup()
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      keys = {
        {
          'g[',
          function()
            require('treesitter-context').go_to_context(vim.v.count1)
          end,
          mode = '',
          desc = 'Move cursor to context'
        },
      },
      config = function()
        require('treesitter-context').setup({
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          line_numbers = true,
          multiline_threshold = 20, -- Maximum number of lines to show for a single context
          trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
          zindex = 20, -- The Z-index of the context window
          on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        })
      end,
    },
  },
}
