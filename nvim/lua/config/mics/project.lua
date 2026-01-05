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
    cmd = { 'SessionLoad', 'SessionLoadLast', 'SessionSave' },
    -- stylua: ignore
    keys = {
      { '<leader>ps', '<cmd>SessionSave<CR>', desc = 'Save session' },
      { '<leader>pl', '<cmd>SessionLoad<CR>', desc = 'Load session' },
      { '<leader>pz', '<cmd>SessionSaveQuit<CR><cmd>wqall<CR>', desc = 'Save session and quit' },
      { '<leader>pp', function() require('config.navigation.snacks.persisted').persisted() end, desc = 'Switch project' },
      -- { "'<tab>", function() require('config.navigation.snacks.persisted').persisted() end, desc = 'Switch project' },
    },
    opts = {
      autostart = true, -- Start recording
      autoload = require('core.state').ui.session_autoload, -- Automatically load the session for the cwd on Neovim startup?
      -- use_git_branch = false,
      -- allowed_dirs = {},
      ignored_dirs = { 'C:/Users/hasan' },
      ---@type fun(): boolean
      should_save = should_save,
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
    },
    config = function(_, opts)
      require('persisted').setup(opts)

      augroup('MY_PERSISTED_HOOKS_AUGROUP')(function(autocmd)
        autocmd({ 'User' }, function()
          vim.cmd([[Neotree filesystem show]])
        end, { pattern = 'PersistedLoadPost' })

        -- Save current layout before manually switching with picker
        autocmd({ 'User' }, function()
          require('persisted').save({ session = vim.g.persisted_loaded_session })
          vim.api.nvim_input('<ESC><cmd>%bd!<CR>')
        end, { pattern = { 'PersistedTelescopeLoadPre', 'PersistedPickerLoadPre' } })

        -- autocmd({ 'User' }, function()
        --   -- Close edgy windows
        --   local ok, edgy = pcall(require, 'edgy.commands')
        --   if ok then
        --     edgy.close()
        --   end
        --
        --   for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        --     if vim.bo[buf].filetype == 'codecompanion' then
        --       vim.api.nvim_buf_delete(buf, { force = true })
        --     end
        --   end
        -- end, { pattern = 'PersistedSavePre' })
      end)
    end,
  },
  -- {
  --   'ptdewey/pendulum-nvim',
  --   config = function()
  --     require('pendulum').setup()
  --   end,
  -- },
  -- {
  --   'lowitea/aw-watcher.nvim',
  --   opts = { -- required, but can be empty table: {}
  --     -- add any options here
  --     -- for example:
  --     aw_server = {
  --       host = '127.0.0.1',
  --       port = 5600,
  --     },
  --   },
  -- },
}
