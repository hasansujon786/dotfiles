local nx = { 'n', 'x' }

return {
  'johmsalas/text-case.nvim',
  lazy = true,
  module = 'textcase',
  opts = { default_keymappings_enabled = true },
  -- commit = 'ec9925b27dd54809653cc766b8673acd979a888e',
  -- stylua: ignore
  keys = {
    { 'gac', desc = 'Convert toCamelCase', mode = nx },
    { 'gad', desc = 'Convert to-dash-case', mode = nx },
    { 'gal', desc = 'Convert to lower case', mode = nx },
    { 'gan', desc = 'Convert TO_CONSTANT_CASE', mode = nx },
    { 'gap', desc = 'Convert ToPascalCase', mode = nx },
    { 'gas', desc = 'Convert to_snake_case', mode = nx },
    { 'gau', desc = 'Convert TO_UPPER_CASE', mode = nx },
    { 'gat', '<cmd>lua require("textcase").quick_replace("to_title_case")<CR>', desc = 'Convert To Title Case', mode = nx },
    { 'gaT', '<cmd>lua require("textcase").lsp_rename("to_title_case")<CR>', desc = 'LSP rename To Title Case', mode = nx },
    { 'ga<space>', '<cmd>lua require("textcase").quick_replace("to_lower_phrase_case")<CR>', desc = 'Convert to lower phrase case', mode = nx },
    { 'ga.', '<cmd>TextCaseOpenTelescope<CR>', desc = 'Open Telescope TextCase', mode = nx },
  },
  cmd = {
    'TextCaseOpenTelescope',
    'TextCaseOpenTelescopeQuickChange',
    'TextCaseOpenTelescopeLSPChange',
    'TextCaseStartReplacingCommand',
  },
}
