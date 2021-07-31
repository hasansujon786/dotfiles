
require("nvim-treesitter.configs").setup {
  -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = { 'html', 'css', 'javascript', 'typescript', 'tsx', 'json', 'lua', 'vue' },

  highlight = {
    enable = true, -- false will disable the whole extension
    use_languagetree = false,
    -- disable = {"dart"}
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
      node_incremental = "<M-w>", -- increment to the upper named parent
      node_decemental = "<M-q>", -- decrement to the previous node
      scope_incremental = "<M-s>", -- increment to the upper scope (as defined in locals.scm)
    },
  },
  context_commentstring = {
    enable = true
  },
  indent = {
    enable = true
  },
  autotag = {
    enable = true,
  },
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
  }
}
