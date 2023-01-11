vim.g.bg_tranparent = false
local M = {}

M.ui = {
  border = {
    style = 'rounded',
    highlight = 'TextInfo',
    text = {
      highlight = 'TextInfo',
      align = 'center',
    },
  },
}

_G.state = {
  file = {
    format_on_save = true,
  },
}

return M
