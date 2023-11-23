local M = {}

_G.state = {
  theme = {
    bg_tranparent = true,
  },
  file = {
    auto_format = false, -- Auto format with null-ls
  },
  treesitter = {
    auto_conceal_html_class = true,
  },
}

M.ui = {
  border = {
    style = 'rounded',
    highlight = 'TextInfo',
  },
  hover = {
    -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    winhighlight = 'Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:Visual,Search:None',
    border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  },
  edgy = {
    open_flutter_log_on_right = true,
  },
  neotree = {
    source_selector_style = 'minimal', -- defalut | minimal
  },
}

M.telescope = {
  todo_keyfaces = { 'TODO:', 'DONE:', 'INFO:', 'FIXME:', 'BUG:', 'FIXIT:', 'ISSUE:', 'OPTIM:', 'OPTIMIZE:' },
}

return M
