require('hasan.project_run').setup({
  on_startup = function (st_utils)
    if st_utils.root_has('pubspec.yaml') then
      return {
        {'flutter run', 'bar'},
        {'fooo', 'bar'},
        {'fooo', 'bar'},
        {'fooo', 'bar'},
      }
    end

    if st_utils.root_has('nvim\\init.lua') then
      return {
        {'kkk', 'bar', function (util)
          util.open_tab(vim.fn.getcwd(), 'lazygit')
        end},
        {'kkk', 'bar'},
        {'kkk', 'bar'},
        {'kkk', 'bar'},
      }
    end

    return {}
  end
})
