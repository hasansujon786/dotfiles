local Icons = require('hasan.utils.ui.icons').Other
return {
  'NeogitOrg/neogit',
  lazy = true,
  cmd = 'Neogit',
  -- commit = '37823b4dcf1955a4544ca4b3dfd8076e402a9562', -- normalize-cwd
  -- commit = '9da48298a1c1e1ea52b4b9b9a4c2c4ded6ac422a',
  commit = '42ebd2a',
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
      telescope = true,
    },
    mappings = {
      -- modify status buffer mappings
      status = {
        -- Adds a mapping with "B" as key that does the "BranchPopup" command
        -- ['B'] = 'BranchPopup',
        -- Removes the default mapping of "s"
        -- ['s'] = '',
        ['<c-r>'] = 'RefreshBuffer',
      },
    },
  },
  dependencies = { 'sindrets/diffview.nvim', 'rebelot/heirline.nvim' },
}
