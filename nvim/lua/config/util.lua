local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  { 'nvim-lua/plenary.nvim', lazy = true, module = 'plenary' },
  { 'MunifTanjim/nui.nvim', lazy = true, module = 'nui' },
  { 'tpope/vim-eunuch', lazy = true, cmd = { 'Delete', 'Move', 'Rename', 'Mkdir', 'Chmod' } },
  { 'tpope/vim-repeat', lazy = true, event = 'BufReadPost', dependencies = 'tpope/vim-surround' },
  {
    'max397574/better-escape.nvim',
    lazy = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      timeout = 350, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      mappings = {
        i = { j = { k = '<Esc>', j = false } },
        c = { j = { k = '<Esc>', j = false } },
        t = { j = { k = '<Esc>', j = false } },
        s = { j = { k = '<Esc>' } },
        v = { j = { k = false } },
      },
    },
  },
  { 'dhruvasagar/vim-table-mode', cmd = { 'TableModeToggle', 'TableModeEnable', 'TableModeRealign' } },
  {
    'hasansujon786/neo-glance.nvim_local',
    dev = true,
    config = function()
      local Icons = require('hasan.utils.ui.icons').Other

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
            fold_closed = Icons.ChevronSlimRight,
            fold_open = Icons.ChevronSlimDown,
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
