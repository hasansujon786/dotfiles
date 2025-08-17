local nx = { 'n', 'x' }

return {
  'johmsalas/text-case.nvim',
  lazy = true,
  module = 'textcase',
  -- commit = 'ec9925b27dd54809653cc766b8673acd979a888e',
  -- stylua: ignore
  config = function()
    require('which-key').add({
      { 'ga', group = 'TextCase' },
      -- TODO: use snacks
      { 'ga.', '<cmd>TextCaseOpenTelescopeQuickChange<CR>', mode = nx, desc = 'Telescope Quick Change' },
      { 'ga,', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', mode = nx, desc = 'Telescope LSP Change' },

      { 'gak', '<cmd>lua require("textcase").quick_replace("to_dash_case")<CR>', desc = 'Convert To Kabab Case', mode = nx },
      { 'gaK', '<cmd>lua require("textcase").lsp_rename("to_dash_case")<CR>', desc = 'LSP rename To Kabab Case', mode = nx },
      { 'gat', '<cmd>lua require("textcase").quick_replace("to_title_case")<CR>', desc = 'Convert To Title Case', mode = nx },
      { 'gaT', '<cmd>lua require("textcase").lsp_rename("to_title_case")<CR>', desc = 'LSP rename To Title Case', mode = nx },
      { 'ga<space>', '<cmd>lua require("textcase").quick_replace("to_lower_phrase_case")<CR>', desc = 'Convert to lower phrase case', mode = nx },
    })
    require('textcase').setup({ default_keymappings_enabled = true })
  end,
  keys = {
    {
      'ga',
      function()
        vim.keymap.del(nx, 'ga')
        vim.schedule(function()
          feedkeys('ga')
        end)
      end,
      desc = 'TextCase',
      mode = nx,
    },
  },
  cmd = {
    'TextCaseOpenTelescope',
    'TextCaseOpenTelescopeQuickChange',
    'TextCaseOpenTelescopeLSPChange',
    'TextCaseStartReplacingCommand',
  },
}
