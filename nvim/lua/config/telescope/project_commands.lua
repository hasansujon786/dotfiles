-- require('telescope').load_extension('project_commands')
return {
  default_commands = {
    {
      'lazygit',
      function(util)
        util.open_tab(vim.fn.getcwd(), 'lazygit')
      end,
    },
    {
      'lf',
      function(util)
        util.open_tab(vim.fn.getcwd(), 'lf')
      end,
    },
    {
      'Open Cwd in VSCode',
      function(_)
        require('hasan.utils.file').openInCode(false)
      end,
    },
  },
  dynamic_commands = function(util)
    if util.root_has('pubspec.yaml') then
      return {
        {
          'Flutter run chrome',
          function()
            require('flutter-tools.commands').run_command('-d chrome --web-port 5000')
          end,
          description = 'Run chrome on port 5000',
        },
        {
          'Pub install',
          function()
            require('config.lsp.servers.dartls.pub').pub_install()
          end,
          description = 'Install packages in you prorject',
        },
      }
    end

    if util.root_has('package.json') then
      return {
        {
          'Package.json',
          function()
            require('telescope._extensions').manager.project_commands.scriptsCommandsFromJSON('package.json')
          end,
        },
      }
    end
  end,
  open_tab_func = function(cwd, user_cmd, opts)
    local generated_cmd = {}
    local useTermName = 'wezterm'

    if useTermName == 'windown_terminal' then
      local winTermPath = 'silent !"wt"'
      local profile = '-p "Bash" C:\\Program Files\\Git\\bin\\bash'
      local command_str = '-c "source ~/dotfiles/bash/.env && %s"'

      generated_cmd = { winTermPath, '-w 0 nt -d', cwd, profile, command_str:format(user_cmd) }
      vim.cmd(table.concat(generated_cmd, ' '))
    elseif useTermName == 'wezterm' then
      generated_cmd = { 'wezterm', 'cli', 'spawn', '--cwd', cwd }

      if opts and opts.kind == 'node-script' then
        local res = vim.fn.systemlist(generated_cmd)
        local script_runner = 'yarn'
        local format_str = '%s %s\r'

        vim.fn.system({
          'wezterm',
          'cli',
          'send-text',
          '--pane-id',
          res[1], -- pane-id
          '--no-paste',
          format_str:format(script_runner, user_cmd),
        })
        return
      end

      table.insert(generated_cmd, user_cmd)
      vim.fn.systemlist(generated_cmd)
    end
    -- vim.cmd('silent !tmux-windowizer $(pwd) ' .. entry.value[2])
  end,
}
