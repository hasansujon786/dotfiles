local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }
return {
  { 'folke/neodev.nvim', lazy = true, ft = { 'lua' } },
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
    keys = { { 'gc', desc = 'Commentary', mode = nxo } },
  },
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
    keys = { { 'ga', mode = nx, desc = 'Text case' } },
    cmd = {
      'TextCaseOpenTelescope',
      'TextCaseOpenTelescopeQuickChange',
      'TextCaseOpenTelescopeLSPChange',
      'TextCaseStartReplacingCommand',
    },
    config = function()
      require('textcase').setup({})
      require('telescope').load_extension('textcase')

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
  {
    'max397574/better-escape.nvim',
    lazy = true,
    event = 'InsertEnter',
    opts = {
      mapping = { 'jk' }, -- a table with mappings to use
      timeout = 350, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
    },
  },
  {
    'hasansujon786/neo-glance.nvim_local',
    dev = true,
    config = function()
      keymap('n', '<leader>e', function()
        vim.cmd.wa()
        R('neo_glance.config')
        R('neo_glance.lsp')
        R('neo_glance.actions')
        R('neo_glance.ui')
        R('neo_glance.ui.list')
        R('neo_glance.ui.preview')
        local glance = R('neo_glance')
        -- local glance = require('neo_glance')
        ---@type NeoGlanceUserConfig
        local config = {
          height = 18,
          border = {
            enable = true,
            top_char = '▁',
            bottom_char = '▁',
          },
          preview_win_opts = {
            relativenumber = false,
          },
          folds = {
            fold_closed = '',
            fold_open = '',
          },
        }

        vim.defer_fn(function()
          glance.setup(config)

          glance:open()
        end, 10)
      end, { desc = 'Open neo-glance' })
    end,
    -- dir = 'E:/repoes/lua/peep.nvim',
  },
}
