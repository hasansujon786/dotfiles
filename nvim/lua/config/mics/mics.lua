local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  {
    'mg979/vim-visual-multi',
    keys = {
      { 'gb', '<Plug>(VM-Find-Under)', desc = 'VM: Select under cursor', mode = 'n' },
      { 'gb', '<Plug>(VM-Find-Subword-Under)', desc = 'VM: Select under cursor', mode = 'x' },
      { 'gB', '<Plug>(VM-Select-All)', desc = 'VM: Select all occurrences', mode = 'n' },
      { 'gB', '<Plug>(VM-Visual-All)', desc = 'VM: Select all occurrences', mode = 'x' },
      { 'gA', mode = nx, desc = 'VM: More Actions' },
      { '<C-n>', mode = nx },
      { '<C-up>', mode = nx },
      { '<C-down>', mode = nx },
    },
    init = function()
      vim.g.VM_leader = 'gA'
      vim.g.VM_theme = ''
      vim.g.VM_maps = {
        -- ['Slash Search'] = 'gM',
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
    'johmsalas/text-case.nvim',
    lazy = true,
    commit = 'ec9925b27dd54809653cc766b8673acd979a888e',
    keys = { { 'ga', mode = nx, desc = 'Text case' } },
    cmd = {
      'TextCaseOpenTelescope',
      'TextCaseOpenTelescopeQuickChange',
      'TextCaseOpenTelescopeLSPChange',
      'TextCaseStartReplacingCommand',
    },
    config = function()
      require('textcase').setup()
      -- require('telescope').load_extension('textcase')

      keymap(nx, 'ga.', '<cmd>TextCaseOpenTelescopeQuickChange<CR>', { desc = 'Telescope Quick Change' })
      keymap(nx, 'ga,', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', { desc = 'Telescope LSP Change' })
    end,
    dependencies = { 'nvim-telescope/telescope.nvim' },
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
}
