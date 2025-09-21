local command = vim.api.nvim_create_user_command

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
  local text = require('hasan.utils.visual').get_range_or_visual_text(ctx.range) or vim.fn.expand('<cWORD>')
  require('hasan.utils.time').parse_time(text)
end, { desc = 'Parse ISO time', range = true })

command('Translate', function(ctx)
  require('hasan.utils.search').translate(ctx)
end, { desc = 'Translate selected text or current word using Google Translate', range = true })
command('Google', function(ctx)
  require('hasan.utils.search').search_with_google(ctx)
end, { desc = 'Search on google', range = true })

command('Dashboard', function()
  Snacks.dashboard.open()
end, { desc = 'Open dashboard' })

command('WezSession', function()
  require('hasan.wezterm.edit-session').select_file()
end, { desc = 'Edit wez-sessions' })

command('CheckWinConfig', function()
  local opts = vim.api.nvim_win_get_config(0)
  dd(opts)
end, { desc = 'Check win config' })

command('DocGenerate', function()
  vim.cmd.wa()
  local ok = pcall(R, 'scripts.minidoc')
  if not ok then
    return vim.notify("module 'scripts.minidoc' not found", 'error', { title = 'minidoc' })
  end
  vim.cmd.checktime()
end, { nargs = 0, desc = 'DocGenerate' })

command('GoErrDeclToggle', function()
  require('config.lsp.servers.gopls.go_err').toggle_inline_err()
end, { nargs = 0, desc = 'GoErrDeclToggle' })
keymap('n', '<Plug>(GoErrDeclToggle)', function()
  require('config.lsp.servers.gopls.go_err').toggle_inline_err()
end, { desc = 'GoErrDeclToggle' })
