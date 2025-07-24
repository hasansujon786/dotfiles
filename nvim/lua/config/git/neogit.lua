local Icons = require('hasan.utils.ui.icons').Other
return {
  'NeogitOrg/neogit',
  lazy = true,
  cmd = 'Neogit',
  commit = '99b811a', -- 5972552 a58ab1befb5608b8ff36a2286360df8263791c1c 001f43f
  keys = {
    { '<leader>gg', '<cmd>Neogit<CR>', desc = 'Open Neogit' },
  },
  opts = {
    graph_style = 'kitty', -- kitty|unicode|ascii -- https://github.com/rbong/flog-symbols
    disable_insert_on_commit = 'auto',
    disable_signs = false,
    disable_hint = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = true,
    auto_refresh = true,
    disable_builtin_notifications = false,
    use_magit_keybindings = false,
    -- commit_editor = {
    --   kind = 'vsplit',
    -- },
    kind = 'tab',
    signs = {
      -- { CLOSED, OPENED }
      section = { Icons.SlimArrowRight, Icons.SlimArrowDownRight },
      item = { Icons.ChevronSlimRight, Icons.ChevronSlimDown },
      hunk = { '', '' },
    },
    integrations = {
      diffview = true,
      telescope = false,
      snacks = true,
    },
    mappings = {
      status = {
        -- ['s'] = '', -- Removes the default mapping of "s"
        ['<c-r>'] = 'RefreshBuffer',
        [']]'] = 'NextSection',
        ['[['] = 'PreviousSection',
      },
    },
  },
  dependencies = { 'sindrets/diffview.nvim', },
}
