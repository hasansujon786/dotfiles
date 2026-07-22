local M = {}

function M.ytm_toggle()
  vim.system({ 'ytm', 'status' }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify(
          result.stderr ~= '' and result.stderr or 'Failed to get YouTube Music status.',
          vim.log.levels.ERROR,
          { title = 'YouTube Music' }
        )
        return
      end

      local ok, status = pcall(vim.json.decode, result.stdout)
      if not ok or type(status) ~= 'table' then
        vim.notify('Failed to parse YouTube Music status.', vim.log.levels.ERROR, { title = 'YouTube Music' })
        return
      end

      local command = {
        [true] = { 'ytm', 'pause' },
        [false] = { 'ytm', 'play' },
      }
      vim.system(command[status.is_playing], { detach = true })
    end)
  end)
end

return M
