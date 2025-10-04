vim.o.laststatus = 3
vim.opt.showcmdloc = 'statusline'

local function get_colors()
  local utils = require('heirline.utils')

  local sline = utils.get_highlight('StatusLine')

  local colors = {
    red = utils.get_highlight('@comment.error').fg,
    yellow = utils.get_highlight('@comment.warning').fg,
    cyan = utils.get_highlight('@comment.note').fg,
    blue = utils.get_highlight('Function').fg,
    green = utils.get_highlight('String').fg,
    purple = utils.get_highlight('Keyword').fg,
    orange = utils.get_highlight('Number').fg,

    muted = utils.get_highlight('WinbarTabContentInactive').fg,
    layer = utils.get_highlight('HeirlineLayer').bg,
    bg = sline.bg or '#2d3343',
    fg = sline.fg,
  }

  return colors
end

require('heirline').setup({
  statusline = require('config.ui.heirline.statusline'),
  winbar = require('config.ui.heirline.winbar').Winbar,
  opts = {
    colors = get_colors,
    disable_winbar_cb = require('config.ui.heirline.winbar').disable_winbar_cb,
  },
})

augroup('THEME_AUGROUP_HEIRLINE')(function(autocmd)
  autocmd('ColorScheme', function()
    require('heirline.utils').on_colorscheme(get_colors)
  end)
end)
