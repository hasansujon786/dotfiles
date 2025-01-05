local M = {}

M.theme = {
  transparency = true,
}

M.treesitter = {
  auto_conceal_html_class = true,
  enabled_context = true,
}

M.ui = {
  border = {
    style = 'rounded',
    highlight = 'DiagnosticHint',
  },
  session_autoload = false,
  fold = {
    persists = true,
  },
  neominimap = {
    width = 90,
    height = 15,
  },
  telescope_border_style = 'edged',
  hover = {
    -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    winhighlight = 'Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:CursorLineFocus,Search:None',
    border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  },
  edgy = {
    open_flutter_log_on_right = true,
  },
  neotree = {
    source_selector_style = 'minimal', -- defalut | minimal
  },
}

M.project = {
  todo_keyfaces = { 'TODO', 'DONE', 'INFO', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'OPTIM', 'OPTIMIZE' },
}

M.border_groups = {
  rounded = {
    prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
    results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
    preview = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
  },
  edged = {
    prompt = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    results = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    preview = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    -- results = { '▁', '▕', '▁', '▏', '🭼', '🭿', '🭿', '🭼' },
  },
  edged_top = {
    prompt = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    preview = { '▔', '▕', ' ', '▏', '🭽', '🭾', '▕', '▏' },
    results = { '▁', '▕', '▁', '▏', '🭼', '🭿', '🭿', '🭼' },
  },
  edged_ivy = {
    prompt = { '▔', ' ', ' ', ' ', '▔', '▔', ' ', ' ' },
    results = { ' ', '▕', ' ', ' ', ' ', '▕', '▕', ' ' },
    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
  empty = {
    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    prompt = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
}

return M
