require('hasan.project_run').setup({
  default_commands = {
    {'lazygit', 'lazygit', function (util)
      util.open_tab(vim.fn.getcwd(), 'lazygit')
    end},
    {'lf', 'lf', function (util)
      util.open_tab(vim.fn.getcwd(), 'lf')
    end},
  },

  on_startup = function (st_utils)
    if st_utils.root_has('pubspec.yaml') then
      return {
        {'flutter run', 'flutter run', function(util)
          util.open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')
        end},
      }
    end

    if st_utils.root_has('package.json') then
      return {
        {'package.json', 'package.json', function()
          require("hasan.project_run").scriptsCommandsFromJSON('package.json')
        end},
      }
    end
    -- if st_utils.root_has('nvim\\init.lua') then
    --   return {
    --   }
    -- end

    return {}
  end
})
