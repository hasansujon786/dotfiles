
require("nvim-treesitter.configs").setup {
  ensure_installed = { 'html', 'css', 'javascript', 'typescript', 'tsx', 'json', 'lua', 'vue', 'dart' },
  highlight = {
    enable = true, -- false will disable the whole extension
    use_languagetree = false,
    -- disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'g<tab>', -- maps in normal mode to init the node/scope selection
      node_incremental = '<tab>', -- increment to the upper named parent
      node_decremental = '<s-tab>', -- decrement to the previous node
      scope_incremental = 'gn', -- increment to the upper scope (as defined in locals.scm)
    },
  },
  context_commentstring = { enable = true },
  indent = { enable = true },
  autotag = { enable = true },
  autopairs = { enable = true },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      -- This shows stuff like literal strings, commas, etc.
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["iP"] = "@parameter.inner",
        ["aP"] = "@parameter.outer",
        ["ik"] = "@call.inner",
        ["ak"] = "@call.outer",
        -- Or you can define your own textobjects like this
        ["iF"] = {
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function",
        },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<Plug>(swap-parameter-next)'] = '@parameter.inner',
      },
      swap_previous = {
        ['<Plug>(swap-parameter-prev)'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = false, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]]"] = "@function.outer",
        ["]m"] = "@class.outer",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
        ["[m"] = "@class.outer",
      },
      goto_next_end = {
        ["]["] = "@function.outer",
        ["]M"] = "@class.outer",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
        ["[M"] = "@class.outer",
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
}
