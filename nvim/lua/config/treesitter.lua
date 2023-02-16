-- TSInstallSync javascript typescript tsx org
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'html', 'vim', 'css', 'json', 'lua', 'vue', 'dart', 'bash', 'help', 'markdown', 'markdown_inline', },
  highlight = {
    enable = true, -- false will disable the whole extension
    use_languagetree = false,
    disable = { 'vim' },
    additional_vim_regex_highlighting = { 'org', 'vim', 'markdown' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
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
        ['ic'] = '@call.inner',
        ['ac'] = '@call.outer',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['am'] = '@class.outer',
        ['im'] = '@class.inner',
        ['aM'] = '@comment.outer',
        ['ak'] = '@pair.outer',
        ['ik'] = '@pair.inner',
        ['ao'] = '@block.outer',
        ['io'] = '@block.inner',
        ['iC'] = '@conditional.inner',
        ['aC'] = '@conditional.outer',
        ['iP'] = '@parameter.inner',
        ['aP'] = '@parameter.outer',
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
local import_pattern = 'javascript,typescript,tsx,typescriptreact,vue,dart'
require('hasan.utils').augroup('MY_TREESITTER_AUGROUP')(function(autocmd)
  autocmd('FileType', 'lua my_treesitter_foldexpr()', { pattern = treesitter_foldtext_filetypes })
  autocmd('FileType', 'let b:treesitter_import_syntax = "import"', { pattern = import_pattern })
end)
