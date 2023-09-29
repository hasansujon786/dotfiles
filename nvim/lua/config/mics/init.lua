local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }
return {
  { 'nvim-lua/plenary.nvim', lazy = true, module = 'plenary' },
  { 'MunifTanjim/nui.nvim', lazy = true, module = 'nui' },
  { 'tpope/vim-eunuch', lazy = true, cmd = { 'Delete', 'Move', 'Rename', 'Mkdir', 'Chmod' } },
  {
    'tpope/vim-repeat',
    lazy = true,
    event = 'BufReadPost',
    dependencies = 'tpope/vim-surround',
  },
  {
    'tpope/vim-commentary',
    keys = { 'gcc', 'gcu', { 'gc', mode = nxo } },
  },
  {
    'dhruvasagar/vim-open-url',
    keys = { { 'gB', mode = nx }, { 'g<CR>', mode = nx }, { 'gG', mode = nx } },
    cmd = 'OpenURL',
  },
  {
    -- TODO: debug keymap
    'mg979/vim-visual-multi',
    keys = { { '<leader>vv', mode = nx }, { '<C-n>', mode = nx } },
    init = function()
      vim.g.VM_leader = '<leader>vv'
      vim.g.VM_theme_set_by_colorscheme = 0
    end,
  },
  {
    'arthurxavierx/vim-caser',
    keys = { { '<leader>cs', mode = nx } },
    init = function()
      vim.g.caser_prefix = '<leader>cs'
    end,
  },
  {
    'unblevable/quick-scope',
    keys = { { 'f', mode = nxo }, { 'F', mode = nxo }, { 't', mode = nxo }, { 'T', mode = nxo } },
    init = function()
      vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
    end,
  },
  {
    'justinmk/vim-sneak',
    keys = { { 's', mode = nx }, { 'S', mode = nx }, { 'z', mode = 'o' }, { 'Z', mode = 'o' } },
    init = function()
      vim.g['sneak#target_labels'] = ';wertyuopzbnmfLGKHWERTYUIQOPZBNMFJ0123456789'
      vim.g['sneak#label'] = 1 -- use <tab> to jump through lebles
      vim.g['sneak#use_ic_scs'] = 1 -- case insensitive sneak
      vim.g['sneak#prompt'] = '  '
    end,
    config = function()
      require('config.mics.sneak')
    end,
  },
  {
    'Konfekt/vim-CtrlXA',
    lazy = true,
    keys = { '<C-a>', '<C-x>' },
    config = function()
      vim.fn['hasan#CtrlXA#update']()
    end,
  },
}
