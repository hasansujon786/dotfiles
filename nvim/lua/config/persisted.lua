local M = {}
local psessions_path = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/')
-- vim.o.sessionoptions

M.setup = function()
  require('persisted').setup({
    dir = psessions_path,
    use_git_branch = false,
    autosave = false,
    autoload = false,
    allowed_dirs = nil,
    ignored_dirs = nil,
    -- before_save = function()
    --   -- Clear out Minimap before saving the session
    --   -- With Minimap open it stops the session restoring to the last cursor position
    --   pcall(vim.cmd, 'bw minimap')
    -- end,
    -- after_save = function()
    --   print('sessions saved')
    -- end,
  })
end

M.loadSession = function()
  local ok, persisted = pcall(require, 'persisted')
  if not ok then
    print('persisted not installed')
    return
  end

  local sessions = persisted.list()
  local path_to_trim = 'C:\\Users\\hasan\\AppData\\Local\\nvim%-data\\sessions\\'

  local sessions_short = {}
  for _, session in pairs(sessions) do
    sessions_short[#sessions_short + 1] = session:gsub(path_to_trim, '')
  end

  require('hasan.utils.ui').menu(sessions_short, {
    title = 'Session to load',
    on_submit = function(item)
      vim.cmd('source ' .. vim.fn.fnameescape(sessions[item._index]))
    end,
  })
end

M.sessionSaveAndQuit = function()
  vim.cmd('wall')
  require('persisted').save()
  vim.cmd('qall')
end

return M
