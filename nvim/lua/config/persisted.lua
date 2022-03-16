local M = {}
local psessions_path = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/')

M.setup = function()
  require('persisted').setup({
    dir = psessions_path,
    use_git_branch = false,
    autosave = false,
    autoload = false,
    options = { 'buffers', 'curdir', 'tabpages', 'winsize' }, -- session options used for saving
    allowed_dirs = nil,
    ignored_dirs = nil,
    before_save = function()
      print('sessions is saving')
    end,
    after_save = function()
      print('sessions saved')
    end,
  })
end

M.loadSession = function()
  local ok, persisted = pcall(require, 'persisted')
  if not ok then
    print('foo')
    return
  end

  local sessions = persisted.list()
  local path_to_trim = 'C:\\Users\\hasan\\AppData\\Local\\nvim%-data\\sessions\\'

  local sessions_short = {}
  for _, session in pairs(sessions) do
    sessions_short[#sessions_short + 1] = session:gsub(path_to_trim, '')
  end

  require('hasan.utils').select('Session to load', sessions_short, function(choice)
    if choice == nil then
      return
    end
    vim.cmd('source ' .. vim.fn.fnameescape(psessions_path .. choice))
  end)
end

return M
