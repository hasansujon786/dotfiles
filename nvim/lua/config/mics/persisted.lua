local psessions_path = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/')
-- vim.o.sessionoptions
return {
  'olimorris/persisted.nvim',
  lazy = false,
  -- module = 'persisted',
  -- cmd = { 'SessionLoad', 'SessionLoadLast', 'SessionSave' },
  keys = {
    { '<leader>ps', '<cmd>SessionSave<CR>', desc = 'Save session' },
    { '<leader>pl', '<cmd>SessionLoad<CR>', desc = 'Load session' },
    { '<leader>pz', '<cmd>wall | qall<CR>', desc = 'Save session and quit' },
    {
      '<leader>pp',
      '<cmd>lua require("telescope._extensions").manager.persisted.persisted()<CR>',
      desc = 'Show session list',
    },
  },
  config = function()
    require('persisted').setup({
      autostart = true, -- Start recording
      autoload = true, -- Automatically load the session for the cwd on Neovim startup?
      save_dir = psessions_path,
      telescope = {
        mappings = {
          copy_session = '<C-c>',
          change_branch = '<C-b>',
          delete_session = '<C-d>',
        },
        icons = {
          selected = ' ',
          dir = '  ',
          branch = ' ',
        },
      },
      ---@type fun(): boolean
      should_save = function()
        -- Do not save if the alpha dashboard is the current filetype
        if vim.bo.filetype == 'alpha' then
          return false
        end
        return true
      end,
      ---@type fun(): any
      on_autoload_no_session = function()
        local ok = pcall(require, 'alpha')
        if ok then
          vim.cmd([[Alpha]])
        end
      end,

      -- use_git_branch = false,
      -- allowed_dirs = {}, -- Table of dirs that the plugin will start and autoload from
      -- ignored_dirs = {}, -- Table of dirs that are ignored for starting and autoloading
    })

    local group = vim.api.nvim_create_augroup('PersistedHooks', { clear = true })
    -- Close edgy windows
    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = 'PersistedSavePre',
      group = group,
      callback = function()
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
    -- Save current layout before manually switching
    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = 'PersistedTelescopeLoadPre',
      group = group,
      callback = function()
        -- Save the currently loaded session
        require('persisted').save({ session = vim.g.persisted_loaded_session })
        vim.api.nvim_input('<ESC><cmd>%bd!<CR>')
      end,
    })
  end,
}
