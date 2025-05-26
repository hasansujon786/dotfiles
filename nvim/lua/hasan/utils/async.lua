local M = {}

---@param cmd string
---@param args string[]
---@param on_exit fun(boolean, any)
---@param opts {cwd:string}
function M.async_cmd(cmd, args, on_exit, opts)
  opts = opts or {}
  local cmd_job = require('plenary.job'):new({ command = cmd, args = args, cwd = opts.cwd })
  cmd_job:after_failure(vim.schedule_wrap(function(job)
    on_exit(false, job:stderr_result())
    cmd_job = nil
  end))
  cmd_job:after_success(vim.schedule_wrap(function(job)
    on_exit(true, job:result())
    cmd_job = nil
  end))
  cmd_job:start()
end

return M
