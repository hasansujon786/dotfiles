vim.g.bg_tranparent = false
local M = {}

M.ui = {
  border = {
    style = 'rounded',
    highlight = 'FloatBorder',
    text = {
      highlight = 'FloatBorder',
      align = 'center',
    },
  },
  icons = {
    diagnotic = { Error = '', Warn = '', Hint = '', Info = '' }
  }
}

return M
