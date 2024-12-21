command('ClearShada', function()
  local shada_path = vim.fn.expand(vim.fn.stdpath('data') .. '/shada')
  local files = vim.fn.glob(shada_path .. '/*', false, true)
  local all_success = 0
  for _, file in ipairs(files) do
    local file_name = vim.fn.fnamemodify(file, ':t')
    if file_name == 'main.shada' then
      -- skip your main.shada file
      goto continue
    end
    local success = vim.fn.delete(file)
    all_success = all_success + success
    if success ~= 0 then
      vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
    end
    ::continue::
  end
  if all_success == 0 then
    vim.print('Successfully deleted all temporary shada files')
  end
end, { desc = 'Clears all the .tmp shada files' })

command('ParseTiemISO', function(ctx)
  local str = nil
  if ctx.range == 2 then
    str = require('hasan.utils').get_visual_selection()
  elseif require('hasan.utils').is_visual_mode() then
    local r = require('hasan.utils.visual').get_visual_region(0, true)
    str = require('hasan.utils.visual').nvim_buf_get_text(0, r.start_row, r.start_col, r.end_row, r.end_col)[1]
  else
    str = vim.fn.expand('<cWORD>')
  end
  require('hasan.utils.time').parse_time(str)
end, { desc = 'Parse ISO time', range = true })

command('Dashboard', function()
  Snacks.dashboard.open()
end, { desc = 'Open dashboard' })

command('CheckWinConfig', function()
  local opts = vim.api.nvim_win_get_config(0)
  dd(opts)
end, { desc = 'Check win config' })

