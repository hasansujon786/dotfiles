local fs_event

---@param template_name string
local dispose_task = function(template_name)
  local overseer = require('overseer')
  local tasks = overseer.list_tasks({
    recent_first = true,
    filter = function(task)
      if not task then
        return false
      end

      return task.is_running and task.name == template_name
    end,
  })

  if not vim.tbl_isempty(tasks) then
    overseer.run_action(tasks[1], 'dispose')
  end
end

---@param template_name string
local function stop_fs_event(template_name)
  if fs_event then
    fs_event:stop()
    fs_event:close()
    fs_event = nil
    dispose_task(template_name)
  end
end

---@param preview_win number
---@param template_name string
local function fix_term_layout_on_file_change(preview_win, template_name)
  for _, path in ipairs({ 'D:/repoes/go-apps/teatest/.temp' }) do
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
            stop_fs_event(template_name)
          end
        end, 100)
      end)
    )
  end
end

local M = {}

function M.run_template(template_name)
  local overseer = require('overseer')
  stop_fs_event(template_name)

  overseer.run_template({ name = template_name }, function(task)
    if task then
      task:add_component({ 'restart_on_save', paths = { vim.uv.cwd() } })

      local main_win = vim.api.nvim_get_current_win()
      overseer.run_action(task, 'open vsplit')

      local preview_win = vim.api.nvim_get_current_win()
      fix_term_layout_on_file_change(preview_win, template_name)

      vim.api.nvim_set_current_win(main_win)
    else
      vim.notify('WatchRun not supported for filetype ' .. vim.bo.filetype, vim.log.levels.ERROR)
    end
  end)
end

function M.open_quickfix_last()
  local overseer = require('overseer')
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify('No tasks found', vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], 'open output in quickfix')
  end
end

return M
