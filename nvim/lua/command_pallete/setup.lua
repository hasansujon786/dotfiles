local CommandPalette = require('command_pallete.command_pallete')

CommandPalette:Group('LSP', {
  { 'Restart tsserver', ':VtsExec restart_tsserver' },
  { 'Restart eslint_d', ':! eslint_d restart' },
  { 'Restart prettierd', ':!prettierd restart' },
  { 'Restart lua-ls', ':LspRestart lua-ls' },
})

CommandPalette:Group('File', {
  { 'Inspect types', ':InspectTwoslashQueries' },
  { 'Toggle inline folds', ':InlineFoldToggle' },
  { 'Search and Replace', ':SearchAndReplace' },
  { 'Toggle env variables', 'CloakToggle' },
})

CommandPalette:Group('Database dialect', {
  {
    'PostgreSQL',
    function()
      require('nikero.database'):set_dialect('postgres')
    end,
  },
  {
    'SQLite',
    function()
      require('nikero.database'):set_dialect('sqlite')
    end,
  },
  {
    'MySQL',
    function()
      require('nikero.database'):set_dialect('mysql')
    end,
  },
  {
    'SQL Server',
    function()
      require('nikero.database'):set_dialect('tsql')
    end,
  },
})

CommandPalette:Group('Git', {
  {
    'View on GitHub',
    function()
      Snacks.gitbrowse()
    end,
  },
  {
    'View PR Diff',
    function()
      vim.ui.input({ prompt = 'PR number: ' }, function(input)
        if not input or input == '' then
          return
        end
        local pr = tonumber(input)
        if not pr then
          vim.notify('Invalid PR number', vim.log.levels.WARN)
          return
        end
        Snacks.picker.gh_diff({ pr = pr })
      end)
    end,
  },
})

CommandPalette:Group('Vim', {
  {
    'Open Lazy',
    function()
      require('lazy').home()
    end,
  },
  { 'Open Mason', ':Mason' },
  {
    'Zen mode',
    function()
      Snacks.zen()
    end,
  },
  { 'Check health', ':checkhealth' },
  {
    'Change colorscheme',
    function()
      Snacks.picker.colorschemes()
    end,
  },
  {
    'Commands',
    function()
      Snacks.picker.commands()
    end,
  },
})

-- CommandPalette:show_all()
