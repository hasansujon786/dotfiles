local Job = require('plenary.job')
local ui = require('flutter-tools.ui')

local function on_pub_get(result, err)
  local timeout = err and 10000 or nil
  P(result)
  ui.notify(result, { timeout = timeout })
end

local pub_get_job = nil

local function run_flutter_cmd(args, msg)
  pub_get_job = Job:new({
    command = 'C:\\tools\\flutter\\bin\\flutter.BAT',
    args = args,
    cwd = vim.loop.cwd(),
  })
  pub_get_job:after_success(vim.schedule_wrap(function(j)
    on_pub_get(j:result())
    pub_get_job = nil
  end))
  pub_get_job:after_failure(vim.schedule_wrap(function(j)
    on_pub_get(j:stderr_result(), true)
    pub_get_job = nil
  end))
  pub_get_job:start()

  if msg ~= nil or msg ~= '' then
    ui.notify(msg, { timeout = 1000 })
  end
end

return {
  run_flutter_cmd = run_flutter_cmd,
}
