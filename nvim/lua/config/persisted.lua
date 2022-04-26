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
    after_save = function()
      print('persisted: session saved')
    end,
  })
end

M.loadSession = function()
  local ok, persisted = pcall(require, 'persisted')
  if not ok then
    print('persisted not installed')
    return
  end

  -- C:/Users/hasan/AppData/Local/nvim-data/sessions
  local path_to_trim = 'C:\\Users\\hasan\\AppData\\Local\\nvim%-data\\sessions\\'

  vim.ui.select(persisted.list(), {
    prompt = 'Select tabs or spaces:',
    format_item = function(item)
      -- return "I'd like to choose " .. item
      local title = item.file_path:gsub(path_to_trim, '')
      return title:gsub('%%', '/')
    end,
  }, function(choice)
    if choice ~= nil then
      -- P(vim.fn.fnameescape(choice.file_path))
      vim.cmd('source ' .. vim.fn.fnameescape(choice.file_path))
    end
  end)
end

M.sessionSaveAndQuit = function()
  vim.cmd('wall')
  require('persisted').save()
  vim.cmd('qall')
end

return M
