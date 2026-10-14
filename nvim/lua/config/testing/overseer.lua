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

    vim.api.nvim_create_user_command('SwiftRunTab', function()
      require('overseer').run_task({ name = 'Swift run (SPM, tab)' })
    end, { desc = 'Swift run in tab' })

    vim.api.nvim_create_user_command('SwiftRunSplit', function()
      require('overseer').run_task({ name = 'Swift run (SPM)' })
    end, { desc = 'Swift run in vertical split, restart on save' })

    vim.api.nvim_create_user_command('SwiftStop', function()
      local overseer = require('overseer')
      local STATUS = require('overseer.constants').STATUS
      local stopped = 0
      for _, task in ipairs(overseer.list_tasks({ status = STATUS.RUNNING })) do
        if task.name:match('swift run') then
          local bufnr = task:get_bufnr()
          -- force = true: kills the job even though restart_on_save holds a ref
          task:dispose(true)
          if bufnr then
            for _, winid in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == bufnr then
                if #vim.api.nvim_list_wins() > 1 then
                  vim.api.nvim_win_close(winid, false)
                end
              end
            end
          end
          stopped = stopped + 1
        end
      end
      if stopped == 0 then
        vim.notify('No running swift tasks', vim.log.levels.INFO)
      end
    end, { desc = 'Stop swift run tasks and close their output' })
  end,
  opts = {
    task_list = {
      direction = 'right',
    },
  },
}
