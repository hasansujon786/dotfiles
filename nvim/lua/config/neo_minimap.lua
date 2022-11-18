local nm = require('neo-minimap')

nm.setup_defaults({
  height_toggle = { 12, 36 },
  hl_group = 'LineNr', -- Number hl
  auto_jump = true,
  width = 44,
  height = 12,
  -- height_toggle_index = 1,
  -- query_index = 1,
  disable_indentation = false,
  win_opts = {
    scrolloff = 2,
    relativenumber = true,
    number = true,
    numberwidth = 1,
    winhl = 'CursorLineNr:LineNr,NormalFloat:',
  },
  open_win_opts = { border = 'rounded' },
})
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

nm.set('zi', { 'dart' }, {
  query = [[
  ;; query
  ((function_signature) @cap) ;; matches function declarations
  ((class_definition) @cap) ;; matches class declarations
  ]],
})
