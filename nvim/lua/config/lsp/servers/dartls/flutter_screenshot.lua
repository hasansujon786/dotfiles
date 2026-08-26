local M = {}

---Take a screenshot of the running Flutter app using the flutter CLI
---@param opts { output: string? }?
function M.screenshot(opts)
  opts = opts or {}

  local ok, ft_commands = pcall(require, 'flutter-tools.commands')
  if not ok or not ft_commands.is_running() then
    vim.notify('Flutter is not running', vim.log.levels.WARN)
    return
  end

  local device = ft_commands.current_device()
  local args = { 'screenshot' }

  if opts and opts.output then
    table.insert(args, '-o')
    table.insert(args, opts.output)
  end
  if device and device.id then
    table.insert(args, '-d')
    table.insert(args, device.id)
  end

  vim.notify('Taking screenshot...', vim.log.levels.INFO)

  local Job = require('plenary.job')
  Job:new({
    command = 'flutter',
    args = args,
    on_exit = function(j, return_code)
      vim.schedule(function()
        if return_code == 0 then
          local msg = ''
          local res = j:result()
          if res ~= nil and #res > 0 then
            msg = table.concat(res, '\n')
          end
          vim.notify(msg or 'Screenshot saved', vim.log.levels.INFO)
        else
          local stderr = table.concat(j:stderr_result(), '\n')
          vim.notify('Screenshot failed: ' .. stderr, vim.log.levels.ERROR)
        end
      end)
    end,
  }):start()
end

-- R('config.lsp.servers.dartls.flutter_screenshot')

return M
