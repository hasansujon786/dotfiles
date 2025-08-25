local M = {}

function M.run_template(template_name)
  local overseer = require('overseer')
  overseer.run_template({ name = template_name }, function(task)
    if task then
      task:add_component({ 'restart_on_save', paths = { vim.uv.cwd() } })
      task:add_component({ 'custom.on_file_change_fix_term_layout' })
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
