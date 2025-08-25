local fs_event, prev_task

local function stop_fs_event()
  if fs_event then
    fs_event:stop()
    fs_event:close()
    fs_event = nil
  end
end

local dispose_task = function(task)
  local overseer = require('overseer')
  if not (task and task.is_running) then
    return
  end

  overseer.run_action(task, 'dispose')
end

---@param preview_win number
local function fix_term_layout_on_file_change(preview_win)
  stop_fs_event()

  for _, path in ipairs({ vim.uv.cwd() .. '/.temp' }) do
    fs_event = assert(vim.loop.new_fs_event())
    fs_event:start(
      path,
      { recursive = true },
      vim.schedule_wrap(function(err, filename, events)
        vim.defer_fn(function()
          if not preview_win then
            return
          end

          local ok = pcall(vim.api.nvim_win_set_cursor, preview_win, { 1, 0 })
          if not ok then
            dispose_task(prev_task)
          end
        end, 100)
      end)
    )
  end
end

return {
  desc = 'Include a description of your component',
  -- Define parameters that can be passed into the component
  params = {},
  editable = true, -- Optional, default true. Set to false to disallow editing this component in the task editor
  constructor = function()
    local overseer = require('overseer')
    dispose_task(prev_task)

    return {
      on_init = function(self, task)
        prev_task = task
        local main_win = vim.api.nvim_get_current_win()
        local ok = pcall(overseer.run_action, task, 'open vsplit')
        if not ok then
          return
        end

        local preview_win = vim.api.nvim_get_current_win()
        fix_term_layout_on_file_change(preview_win)

        vim.api.nvim_set_current_win(main_win)
      end,
      -- Called when the task is started
      -- on_start = function(self, task)
      --   dd('on_start')
      -- end,
      on_dispose = function(self, task)
        stop_fs_event()
        prev_task = nil
        -- Called when the task is disposed
        -- Will be called IFF on_init was called, and will be called exactly once.
        -- This is a good place to free resources (e.g. timers, files, etc)
      end,
    }
  end,
}
