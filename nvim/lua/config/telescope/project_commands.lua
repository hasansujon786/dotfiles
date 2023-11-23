-- require('telescope').load_extension('project_commands')
return {
  commands = {
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
    dynamic_commands = function(utils)
      if utils.root_has('pubspec.yaml') then
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
              require('config.lsp.servers.flutter.pub').pub_install()
            end,
            description = 'Install packages in you prorject',
          },
        }
      end

      if utils.root_has('package.json') then
        return {
          {
            'Package.json',
            function()
              require('telescope._extensions').manager.project_commands.scriptsCommandsFromJSON('package.json')
            end,
          },
        }
      end
      return {}
    end,
  },
}
