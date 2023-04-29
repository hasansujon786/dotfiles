local nm = require('neo-minimap')

nm.setup_defaults({
  height_toggle = { 15, 36 },
  auto_jump = true,
  width = 44,
  height = 15,
  -- height_toggle_index = 1,
  -- query_index = 1,
  disable_indentation = false,
  win_opts = {
    scrolloff = 2,
    relativenumber = true,
    number = true,
    numberwidth = 1,
    -- winhl = 'CursorLineNr:LineNr,NormalFloat:',
  },
  open_win_opts = { border = 'rounded', zindex = 1111 },
  override_default_hl = {
    NeoMinimapCursorLine = { link = 'CursorLine' },
    NeoMinimapBorder = { link = 'FloatBorder' },
    NeoMinimapBackground = { link = 'Normal' },
    NeoMinimapLineNr = { link = 'LineNr' },
  },
})
-- nm.source_on_save('~\dotfiles\nvim\lua\config\neo_minimap.lua')

-- Lua
nm.set({ 'zo', 'zi', 'zu' }, '*.lua', {
  events = { 'BufEnter' },
  query = {
    [[
    ;; query
    ((function_declaration) @cap) ;; matches function declarations
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]],
    [[
    ;; query
    ((comment) @cap)
    ]],
    [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))

    ((for_statement) @cap) ;; matches for loops
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
    ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap) ;; matches vim.keymap.set
    ]],
  },

  regex = {
    -- {},
    -- { [[^\s*--\s\+\w\+]], [[--\s*=]] },
    -- {},
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
nm.set({ 'zo', 'zi' }, { 'typescriptreact', 'javascriptreact', 'javascript' }, {
  query = {
    [[
    ;; query
    ((function_declaration) @cap) ;; matches function declarations
    ((variable_declarator(arrow_function) @cap))
    ((identifier) @cap (#vim-match? @cap "^use[A-Z]")) ;; matches hooks (useState, useEffect, use***, etc...)
    ((pair(arrow_function) @cap))
    ((pair(function) @cap))
    ((method_definition) @cap)
    ; ((arrow_function) @cap) ;; any arrow functions
    ]],
    [[
    ;; query
    ((comment) @cap)
    ]],
  },
  regex = {
    -- {},
    -- {
    --   [[\(const\|let\)\s\w*\s=\s\(.*\)\s=>]], -- arrow_function with declarations
    -- },
  },
})

nm.set('zo', { 'dart' }, {
  query = {
    [[
    ;; query
    ((function_signature) @cap) ;; matches function declarations
    ((class_definition) @cap) ;; matches class declarations
    ]],
    [[
    ;; query
    ((comment) @cap)
    ]],
  },
})
