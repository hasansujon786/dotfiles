local q = require('vim.treesitter.query')

local function i(value)
  print(vim.inspect(value))
end

local bufnr = 7

local language_tree = vim.treesitter.get_parser(bufnr, 'dart')
local syntax_tree = language_tree:parse()
local root = syntax_tree[1]:root()

local query = vim.treesitter.parse_query(
  'dart',
  [[
  (enum_declaration (enum_body (enum_constant name: (identifier) @dartType)) )
  ]]
)

for _, captures, metadata in query:iter_matches(root, bufnr) do
  i(q.get_node_text(captures[1], bufnr))
  -- i(q.get_node_text(captures, bufnr))
  -- i(captures)
  -- i(metadata)
end

-- require('vim.treesitter.query').set_query('dart', 'highlights', '(enum_declaration (enum_body (enum_constant name: (identifier) @function)))')

-- local query = vim.treesitter.parse_query(
--   'java',
--   [[
-- (method_declaration
--     (modifiers
--         (marker_annotation
--             name: (identifier) @annotation (#eq? @annotation "Test")))
--     name: (identifier) @method (#offset! @method))
-- ]]
-- )
