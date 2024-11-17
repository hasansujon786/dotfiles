local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  {
    'mg979/vim-visual-multi',
    keys = {
      { 'gb', '<Plug>(VM-Find-Under)', desc = 'VM: Select under cursor', mode = 'n' },
      { 'gb', '<Plug>(VM-Find-Subword-Under)', desc = 'VM: Select under cursor', mode = 'x' },
      { 'gB', '<Plug>(VM-Select-All)', desc = 'VM: Select all occurrences', mode = 'n' },
      { 'gB', '<Plug>(VM-Visual-All)', desc = 'VM: Select all occurrences', mode = 'x' },
      { 'gmA', '<Plug>(VM-Select-All)', desc = 'VM: Select all occurrences', mode = 'n' },
      { 'gmA', '<Plug>(VM-Visual-All)', desc = 'VM: Select all occurrences', mode = 'x' },
      { '<C-up>', mode = nx },
      { '<C-down>', mode = nx },
    },
    init = function()
      vim.g.VM_leader = 'gm'
      vim.g.VM_theme = ''
      vim.g.VM_maps = {
        -- ['Slash Search'] = 'gM',
        ['Find Under'] = 0,
        ['Find Subword Under'] = 0,
        ['I BS'] = '<C-h>',
      }
    end,
    config = function()
      augroup('MY_VM')(function(autocmd)
        autocmd('User', function()
          vim.api.nvim_set_hl(0, 'CurSearch', { link = 'None' })
        end, { pattern = 'visual_multi_start' })
        autocmd('User', function()
          vim.api.nvim_set_hl(0, 'CurSearch', { link = 'IncSearch' })
        end, { pattern = 'visual_multi_exit' })
      end)
    end,
  },
  {
    'jinh0/eyeliner.nvim',
    keys = { { 'f', mode = nxo }, { 'F', mode = nxo }, { 't', mode = nxo }, { 'T', mode = nxo } },
    opts = {
      dim = false,
      highlight_on_key = true,
    },
  },
  {
    'Wansmer/treesj',
    opts = {
      use_default_keymaps = false,
      max_join_length = 1000,
      -- langs = {},
      dot_repeat = true,
    },
    keys = {
      { '<leader>fm', '<cmd>TSJToggle<CR>', desc = 'TreeSJ: Toggle' },
      { '<leader>fj', '<cmd>TSJSplit<CR>', desc = 'TreeSJ: Split' },
      { '<leader>fJ', '<cmd>TSJJoin<CR>', desc = 'TreeSJ: Join' },
    },
  },
  {
    'johmsalas/text-case.nvim',
    lazy = true,
    module = 'textcase',
    config = function()
      require('which-key').add({
        { 'ga', group = 'TextCase' },
        { 'ga.', '<cmd>TextCaseOpenTelescopeQuickChange<CR>', mode = nx, desc = 'Telescope Quick Change' },
        { 'ga,', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', mode = nx, desc = 'Telescope LSP Change' },
        { 'ga,', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', mode = nx, desc = 'Telescope LSP Change' },
      })
      require('textcase').setup({ default_keymappings_enabled = true })
    end,
    -- commit = 'ec9925b27dd54809653cc766b8673acd979a888e',
    keys = {
      {
        'ga',
        function()
          vim.cmd('Lazy load text-case.nvim')
          vim.defer_fn(function()
            vim.keymap.del(nx, 'ga')
            feedkeys('ga')
          end, 10)
        end,
        desc = 'TextCase',
        mode = nx,
      },
      {
        'gak',
        '<cmd>lua require("textcase").quick_replace("to_dash_case")<CR>',
        mode = nx,
        desc = 'Convert to-kabab-case',
      },
      {
        'gaK',
        '<cmd>lua require("textcase").lsp_rename("to_dash_case")<CR>',
        mode = nx,
        desc = 'LSP rename to-kabab-case',
      },
    },
    cmd = {
      'TextCaseOpenTelescope',
      'TextCaseOpenTelescopeQuickChange',
      'TextCaseOpenTelescopeLSPChange',
      'TextCaseStartReplacingCommand',
    },
  },
}
