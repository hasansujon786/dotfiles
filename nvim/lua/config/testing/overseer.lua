return {
  'stevearc/overseer.nvim',
  cmd = { 'OverseerOpen', 'OverseerRunCmd', 'OverseerRun' },
  init = function()
    vim.api.nvim_create_user_command('WatchRun', function()
      require('hasan.make').run_template('make run')
    end, { desc = 'Execute make run on file change' })

    vim.api.nvim_create_user_command('OverseerQuickfixOutput', function()
      require('hasan.make').open_quickfix_last()
    end, { desc = 'open output in quickfix form last task' })
  end,
  opts = {
    task_list = {
      direction = 'right',
    },
  },
}
