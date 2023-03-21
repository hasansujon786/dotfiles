vim.g.bg_tranparent = true
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
    auto_format = false,
  },
  treesitter = {
    auto_conceal_html_class = true,
  },
}

return M
