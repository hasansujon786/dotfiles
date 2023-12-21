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
  })

  local group = vim.api.nvim_create_augroup('PersistedHooks', { clear = true })
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'PersistedSavePre',
    group = group,
    callback = function()
      local ok, edgy = pcall(require, 'edgy.commands')

      if ok then
        edgy.close()
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'PersistedTelescopeLoadPre',
    group = group,
    callback = function(session)
      -- Save the currently loaded session
      require('persisted').save({ session = vim.g.persisted_loaded_session })
      vim.api.nvim_input('<ESC><cmd>%bd!<CR>')
    end,
  })
end

M.save_and_exit = function()
  vim.cmd([[
    wall
    SessionSave
    qall
  ]])
end

M.load_session = function()
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

return M
