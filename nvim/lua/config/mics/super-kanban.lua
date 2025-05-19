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

          kanban.open('test.md')
        end,
      },
    },
    config = function()
      -- require('super-kanban').setup()
      -- keymap('n', )
    end,
  },
  {
    'arakkkkk/kanban.nvim',
    commit = '90a3d235f87d708febe3215aeeeb6fc762f3adfa',
    lazy = true,
    enabled = true,
    opts = {
      markdown = {
        description_folder = '/tasks/', -- Path to save the file corresponding to the task.
        list_head = '## ',
      },
    },
  },
}
