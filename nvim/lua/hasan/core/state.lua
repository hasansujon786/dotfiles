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
  hover = {
    -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    winhighlight = 'Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:Visual,Search:None',
    border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
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
