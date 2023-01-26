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
    format_save = false,
  },
  treesitter = {
    auto_conceal_html_class = true
  }
}

return M
