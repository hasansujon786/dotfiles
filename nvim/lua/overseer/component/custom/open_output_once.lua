-- Custom overseer component: open task output once, reuse it on restart.
--
-- Problem it solves: the builtin `open_output` component with
-- `on_start = "always"` calls `Task:open_output("vertical")` on EVERY start,
-- and that function always does `vsplit + set buf`. Overseer core already
-- swaps the old output buffer into existing windows on restart
-- (`replace_buffer_in_wins` in task.lua), so the builtin behavior leaves you
-- with: old split (now showing new output too) + one brand-new split.
-- Every `:w` with `restart_on_save` then adds another split.
--
-- This component opens the output only when no window is currently showing
-- this task. On restart the existing split is reused automatically by core.
return {
  desc = 'Open task output once, reuse window on restart (no split spam)',
  params = {
    direction = {
      desc = 'Where to open the task output',
      type = 'enum',
      choices = { 'vertical', 'horizontal', 'float', 'tab', 'dock' },
      default = 'vertical',
    },
    focus = {
      desc = 'Focus the output window when it is opened',
      type = 'boolean',
      default = false,
    },
    close_on_exit = {
      desc = 'Close the output window/tab when the task process exits',
      type = 'boolean',
      default = false,
    },
  },
  editable = true,
  constructor = function(params)
    local direction = params.direction or 'vertical'
    local focus = params.focus or false
    local close_on_exit = params.close_on_exit or false

    ---@param task overseer.Task
    local function task_shown_in_a_win(task)
      local new_bufnr = task:get_bufnr()
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(winid) then
          local ok, bufnr = pcall(vim.api.nvim_win_get_buf, winid)
          if ok and bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            -- New buffer may not have b:overseer_task set yet at on_start
            -- time (core sets it after dispatch), so check both.
            if bufnr == new_bufnr then
              return winid
            end
            local task_id = vim.b[bufnr].overseer_task
            if task_id == task.id then
              return winid
            end
          end
        end
      end
      return nil
    end

    ---@param task overseer.Task
    local function open_output(task)
      if direction == 'dock' then
        local window = require('overseer.window')
        window.open({
          direction = 'bottom',
          enter = focus,
          focus_task_id = task.id,
        })
      else
        local cur_win = vim.api.nvim_get_current_win()
        ---@cast direction 'float'|'tab'|'vertical'|'horizontal'
        task:open_output(direction)
        if not focus and vim.api.nvim_win_is_valid(cur_win) then
          vim.api.nvim_set_current_win(cur_win)
        end
      end
    end

    return {
      on_start = function(_, task)
        -- A window already shows this task (first start, or pre-restart
        -- buffer): do nothing. Core's replace_buffer_in_wins() will swap
        -- the fresh output buffer into it right after on_start.
        if task_shown_in_a_win(task) then
          return
        end
        open_output(task)
      end,
      on_complete = function(_, task)
        if not close_on_exit then
          return
        end
        local bufnr = task:get_bufnr()
        if not bufnr then
          return
        end
        for _, winid in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == bufnr then
            -- Never close the last window; just leave it.
            if #vim.api.nvim_list_wins() > 1 then
              vim.api.nvim_win_close(winid, false)
            end
          end
        end
      end,
    }
  end,
}
