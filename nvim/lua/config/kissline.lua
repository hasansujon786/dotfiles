-- { 'hasansujon786/kissline.nvim', config = function() require('config.kissline') end },
local clicable = require('kissline.utils.atoms').clicable

local winbars = {
  explorer = function()
    -- '▎ EXPLORER            '
    return string.format(
      '▎ EXPLORER     %s %s %s %s',
      clicable(' ', 'explorer_new'),
      clicable(' ', 'explorer_refesh'),
      clicable(' ', 'explorer_collasp_all'),
      clicable(' ', 'explorer_menu', 3)
    )
  end,
}

require('kissline').setup({
  disable_line = true,
  disable_tab = true,
  -- tab_style = 'angel_bar',
  eneble_winbar = true,
  custon_winbar = {
    -- { title[1], tabHL[2], showActiveBar[3], showCloseBtn[4], showBarSeparatyr[5], endColor[6] }
    NvimTree = function()
      return { winbars.explorer(), 'NvimTreeWinBar', false, false, false }
    end,
    Outline = function()
      return { '▎ OUTLINE', 'NvimTreeWinBar', false, false, false }
    end,
    alpha = function()
      return { '', '', false, false, false }
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

-- _G.explorer_new = function()
--   require('nvim-tree.api').fs.create()
-- end
-- _G.explorer_refesh = function()
--   require('nvim-tree.api').tree.reload()
-- end
-- _G.explorer_collasp_all = function()
--   vim.cmd([[NvimTreeOpen]])
--   require('hasan.utils.vinegar').actions.jump_to_root()
-- end
-- _G.explorer_menu = function(val)
--   P('explorer_menu', val)
-- end
