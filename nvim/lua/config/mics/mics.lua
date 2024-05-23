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
      { 'gB', '<Plug>(VM-Select-All)', desc = 'VM: Select under cursor', mode = 'n' },
      { 'gB', '<Plug>(VM-Visual-All)', desc = 'VM: Select under cursor', mode = 'x' },
      { '<leader>n', mode = nx },
      { '<C-n>', mode = nx },
      { '<C-up>', mode = nx },
      { '<C-down>', mode = nx },
    },
    init = function()
      vim.g.VM_leader = '<leader>n'
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
    'arthurxavierx/vim-caser',
    event = 'VeryLazy',
    config = function()
      vim.g.caser_no_mappings = 1

      local maps = {
        c = { '<Plug>CaserCamelCase', '<Plug>CaserVCamelCase', 'Caser: Camel case' },
        p = { '<Plug>CaserMixedCase', '<Plug>CaserVMixedCase', 'Caser: Pascal case' },

        ['-'] = { '<Plug>CaserKebabCase', '<Plug>CaserVKebabCase', 'Caser: Kebab case' },
        k = { '<Plug>CaserKebabCase', '<Plug>CaserVKebabCase', 'Caser: Kebab case' },
        K = { '<Plug>CaserTitleKebabCase', '<Plug>CaserVTitleKebabCase', 'Caser: Title kebab case' },

        s = { '<Plug>CaserSnakeCase', '<Plug>CaserVSnakeCase', 'Caser: Snake case' },
        ['_'] = { '<Plug>CaserSnakeCase', '<Plug>CaserVSnakeCase', 'Caser: Snake case' },

        U = { '<Plug>CaserUpperCase', '<Plug>CaserVUpperCase', 'Caser: Upper snake case' },

        t = { '<Plug>CaserTitleCase', '<Plug>CaserVTitleCase', 'Caser: Title case' },
        S = { '<Plug>CaserSentenceCase', '<Plug>CaserVSentenceCase', 'Caser: Title case' },

        ['.'] = { '<Plug>CaserDotCase', '<Plug>CaserVDotCase', 'Caser: Dot case' },
        ['<space>'] = { '<Plug>CaserSpaceCase', '<Plug>CaserVSpaceCase', 'Caser: Space case' },
      }
      for key, value in pairs(maps) do
        keymap('n', 'ga' .. key, value[1], { desc = value[3] })
        keymap('x', 'a' .. key, value[2], { desc = value[3] })
      end
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
