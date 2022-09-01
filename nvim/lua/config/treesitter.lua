local utils = require('hasan.utils')
-- TSInstallSync javascript typescript tsx
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'html', 'vim', 'css', 'json', 'lua', 'vue', 'dart', 'bash' },
  highlight = {
    enable = true, -- false will disable the whole extension
    use_languagetree = false,
    disable = { 'vim' },
    additional_vim_regex_highlighting = { 'org', 'html', 'vim' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'g<tab>', -- maps in normal mode to init the node/scope selection
      scope_incremental = 'V', -- increment to the upper scope (as defined in locals.scm)
      node_incremental = '<tab>', -- increment to the upper named parent
      node_decremental = '<s-tab>', -- decrement to the previous node
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
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ic'] = '@call.inner',
        ['ac'] = '@call.outer',
        ['iP'] = '@parameter.inner',
        ['aP'] = '@parameter.outer',
        ['am'] = '@class.outer',
        ['im'] = '@class.inner',
        ['ao'] = '@block.outer',
        ['io'] = '@block.inner',
        ['aM'] = '@comment.outer',
        -- @conditional.inner
        -- @conditional.outer
        -- @loop.inner
        -- @loop.outer
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
        [']]'] = '@function.outer',
        [']m'] = '@class.outer',
      },
      goto_previous_start = {
        ['[['] = '@function.outer',
        ['[m'] = '@class.outer',
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

function Treesitter_foldexpr()
  vim.defer_fn(function()
    vim.wo.foldmethod = 'expr'

    if vim.bo.filetype == 'org' then
      vim.wo.foldexpr = 'OrgmodeFoldExpr()'
    elseif vim.b.treesitter_import_syntax ~= nil then
      vim.wo.foldexpr = string.format(
        "v:lnum==1?'>1':getline(v:lnum)=~'%s'?1:nvim_treesitter#foldexpr()",
        vim.b.treesitter_import_syntax
      )
    else
      vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
    end
  end, 50)
end

local treesitter_foldtext_filetypes = 'html,css,javascript,typescript,tsx,typescriptreact,json,lua,vue,dart,org'
local autocmds = {
  TS_fold = {
    { 'FileType', treesitter_foldtext_filetypes, 'lua Treesitter_foldexpr()' },
    { 'FileType', 'javascript,typescript,tsx,typescriptreact,vue,dart', 'let b:treesitter_import_syntax = "import"' },
  },
}

utils.create_augroups(autocmds)
