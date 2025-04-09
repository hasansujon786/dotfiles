return {
  'super-kanban.nvim',
  dev = true,
  dependencies = {
    {
      'arakkkkk/kanban.nvim',
      enabled = true,
      opts = {
        markdown = {
          description_folder = '/tasks/', -- Path to save the file corresponding to the task.
          list_head = '## ',
        },
      },
    },
  },
  keys = {
    {
      '<space>m',
      function()
        vim.cmd([[wa]])
        local kanban = R('super-kanban')

        vim.defer_fn(function()
          kanban.open('todo.md')
        end, 100)
      end,
    },
  },
  config = function()
    -- require('super-kanban').setup()
    -- keymap('n', )
  end,
}
