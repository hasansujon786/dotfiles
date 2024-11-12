return {
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
}
