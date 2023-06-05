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
    auto_format = false, -- Auto format with null-ls
  },
  treesitter = {
    auto_conceal_html_class = true,
  },
  theme = {
    bg_tranparent = true,
  },
}

M.telescope = {
  todo_keyfaces = { 'TODO:', 'DONE:', 'INFO:', 'FIXME:', 'BUG:', 'FIXIT:', 'ISSUE:', 'OPTIM:', 'OPTIMIZE:' },
}

return M
