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
            'flutter run',
            function(util)
              util.open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')
            end,
          },
          {
            'pub install',
            function()
              require('config.lsp.servers.flutter.pub').pub_install()
            end,
          },
        }
      end

      if utils.root_has('package.json') then
        return {
          {
            'package.json',
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
