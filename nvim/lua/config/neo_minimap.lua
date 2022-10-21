local nm = require('neo-minimap')

-- nm.source_on_save('~\dotfiles\nvim\lua\config\neo_minimap.lua')

-- Lua
nm.set({ 'zi', 'zo', 'zu' }, '*.lua', {
  events = { 'BufEnter' },
  query = {
    [[
    ;; query
    ((function_declaration) @cap) ;; matches function declarations
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]],
    1,
    [[
    ;; query
    ((for_statement) @cap) ;; matches for loops
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
    ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap) ;; matches vim.keymap.set
    ]],
    [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]],
  },

  regex = {
    {},
    { [[^\s*--\s\+\w\+]], [[--\s*=]] },
    {},
  },

  search_patterns = {
    { 'function', '<C-j>', true },
    { 'function', '<C-k>', false },
    { 'keymap', '<A-j>', true },
    { 'keymap', '<A-k>', false },
  },

  -- auto_jump = false,
  height_toggle = { 12, 36 },
  hl_group = 'Number', -- Number hl

  open_win_opts = { border = 'rounded' },
  win_opts = {
    scrolloff = 1,
    relativenumber = true,
    numberwidth = 1,
  },
})
-- ~\dotfiles\nvim\lua\snips\all.lua
-- nm.set({ 'zo' }, '*lua/snips/*.lua', { -- "mapping", "pattern"
--   query = {},
--   regex = {
--     { [[--.*\w]] },
--   },
--   events = { 'BufEnter' }, -- events
-- })

-- Typescript React
nm.set('zi', { 'typescriptreact', 'javascriptreact', 'javascript' }, {
  query = [[
  ;; query
  ((function_declaration) @cap) ;; matches function declarations
  ((arrow_function) @cap) ;; matches arrow functions
  ((identifier) @cap (#vim-match? @cap "^use.*")) ;; matches hooks (useState, useEffect, use***, etc...)
  ]],
})
