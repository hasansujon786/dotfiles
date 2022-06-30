require('project_nvim').setup({ exclude_dirs = { 'c:' } })
require('telescope').load_extension('projects')

require('project_run').setup({
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
            require('hasan.telescope.custom').pub_install()
          end,
        },
      }
    end

    if utils.root_has('package.json') then
      return {
        {
          'package.json',
          function()
            require('project_run').scriptsCommandsFromJSON('package.json')
          end,
        },
      }
    end
    return {}
  end,
})
