require('kissline').setup({
  disable_line = true,
  disable_tab = true,
  -- tab_style = 'angel_bar',
  eneble_winbar = true,
  actions = {
    rename = {
      eneble = true,
      fn = function(_)
        require('hasan.utils.ui').rename_current_file()
      end,
    },
  },
})
