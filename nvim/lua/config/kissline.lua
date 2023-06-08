require('kissline').setup({
  disable_line = true,
  disable_tab = true,
  -- tab_style = 'angel_bar',
  eneble_winbar = true,
  custon_winbar = {
    -- { title[1], tabHL[2], showActiveBar[3], showCloseBtn[4], showBarSeparatyr[5], endColor[6] }
    NvimTree = function()
      return { '         EXPLORER         ', 'NvimTreeWinBar', false, false, false }
    end,
    Outline = function()
      return { '          OUTLINE', 'WhichKeySeparator', false, false, false }
    end,
  },
  actions = {
    rename = {
      eneble = true,
      fn = function(_)
        require('hasan.utils.ui').rename_current_file()
      end,
    },
  },
})
