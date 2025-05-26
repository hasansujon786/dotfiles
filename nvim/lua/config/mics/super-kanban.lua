return {
  {
    'super-kanban.nvim',
    dev = true,
    keys = {
      {
        '<space>m',
        function()
          vim.cmd([[wa]])
          local kanban = R('super-kanban')
          vim.defer_fn(function()
            kanban.open('test.md')
          end, 300)
        end,
      },
    },
    opts = {},
    -- config = function()
    --   require('super-kanban').setup()
    -- end,
  },
  {
    'arakkkkk/kanban.nvim',
    lazy = true,
    cmd = { 'KanbanOpen', 'KanbanCreate' },
    enabled = false,
    opts = {},
  },
}
