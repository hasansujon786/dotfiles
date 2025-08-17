local should_save = function()
  -- Do not save if the dashboard is the current filetype
  if vim.bo.filetype == 'snacks_dashboard' then
    return false
  end
  return true
end

vim.api.nvim_create_user_command('SessionSaveQuit', function()
  if should_save() then
    require('persisted').save()
  end
end, { nargs = 0, desc = 'SessionSaveQuit' })

return {
  {
    'ahmedkhalf/project.nvim',
    event = 'VeryLazy',
    main = 'project_nvim',
    opts = {
      detection_methods = { 'pattern' },
      exclude_dirs = { 'c:' },
      patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'pubspec.yaml' }, -- 'package.json'
      show_hidden = false,
    },
  },
  {
    'olimorris/persisted.nvim',
    lazy = not require('core.state').ui.session_autoload,
    enabled = not vim.g.vscode,
    module = 'persisted',
    cmd = { 'SessionLoad', 'SessionLoadLast', 'SessionSave' },
    keys = {
      { '<leader>ps', '<cmd>SessionSave<CR>', desc = 'Save session' },
      { '<leader>pl', '<cmd>SessionLoad<CR>', desc = 'Load session' },
      { '<leader>pz', '<cmd>SessionSaveQuit<CR><cmd>wqall<CR>', desc = 'Save session and quit' },
      { '<leader>pp', function() require('config.navigation.snacks.persisted').persisted() end, desc = 'Switch project' },
      { "'<tab>", function() require('config.navigation.snacks.persisted').persisted() end, desc = 'Switch project' },
    },
    config = function()
      local group = vim.api.nvim_create_augroup('PersistedHooks', { clear = true })
      local psessions_path = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/')

      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'PersistedSavePre',
        group = group,
        callback = function()
          -- Close edgy windows
          local ok, edgy = pcall(require, 'edgy.commands')
          if ok then
            edgy.close()
          end

          -- for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          --   if vim.bo[buf].filetype == 'codecompanion' then
          --     vim.api.nvim_buf_delete(buf, { force = true })
          --   end
          -- end
        end,
      })

      -- Save current layout before manually switching with Telescope
      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = { 'PersistedTelescopeLoadPre', 'PersistedPickerLoadPre' },
        group = group,
        callback = function()
          -- Save the currently loaded session
          require('persisted').save({ session = vim.g.persisted_loaded_session })
          vim.api.nvim_input('<ESC><cmd>%bd!<CR>')
        end,
      })

      require('persisted').setup({
        autostart = true, -- Start recording
        autoload = require('core.state').ui.session_autoload, -- Automatically load the session for the cwd on Neovim startup?
        save_dir = psessions_path,
        telescope = {
          mappings = {
            copy_session = '<C-c>',
            change_branch = '<C-b>',
            delete_session = '<C-x>',
          },
          icons = {
            selected = '➤ ',
            dir = '󰝰  ',
            branch = ' ',
          },
        },
        -- use_git_branch = false,
        -- allowed_dirs = {},
        ignored_dirs = { 'C:/Users/hasan' },
        ---@type fun(): boolean
        should_save = should_save,
      })
    end,
  },
}
