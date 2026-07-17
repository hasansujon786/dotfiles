local hover = require('core.state').ui.hover
local sidebar = require('core.state').ui.sidebar

local M = {}

local function winhighlight_from(tbl)
  return table.concat(tbl, ',')
end

local sidebar_hl = {
  root = 'FloatBorder:EdgyWinSeparator',
  input = winhighlight_from({
    'Normal:SidebarDark',
    'NormalNC:SidebarDark',
    'FloatBorder:SidebarDarkBorder',
    'FloatTitle:SidebarDarkTitlte',
  }),
  list = winhighlight_from({
    'Normal:SidebarDark',
    'NormalNC:SidebarDark',
  }),
  preview = winhighlight_from({
    'Normal:SidebarDark',
    'NormalNC:SidebarDark',
    'FloatBorder:SidebarDarkBorder',
    'FloatTitle:SnacksPickerTitle',
  }),
}

function M.get_default()
  return {
    layout = {
      box = 'horizontal',
      width = 0.8,
      min_width = 120,
      height = 0.8,
      {
        box = 'vertical',
        border = hover.border,
        title = '{title} {live} {flags}',
        { win = 'input', height = 1, border = 'bottom' },
        { win = 'list', border = 'none' },
      },
      { win = 'preview', title = '{preview}', border = hover.border, width = 0.5 },
    },
  }
end

function M.get_dropdown(preview)
  return {
    preview = preview,
    layout = {
      row = preview and 0 or nil,
      height = preview and 0.7 or 0.4,
      backdrop = false,
      width = 0.4,
      min_width = 86,
      border = 'none',
      box = 'vertical',
      {
        win = 'preview',
        height = 0.45,
        border = { '🭽', '▔', '🭾', '▕', '', '', '', '▏' },
        -- border = { '🭽', '▔', '🭾', '▕', '▔', '▔', '▔', '▏' },
      },
      {
        box = 'vertical',
        border = hover.border,
        title = '{source} {live}',
        title_pos = 'center',
        { win = 'input', height = 1, border = 'bottom' },
        { win = 'list', border = 'none' },
      },
    },
  }
end

function M.get_ivy(mini)
  return {
    layout = {
      box = 'vertical',
      backdrop = false,
      row = -1,
      width = 0,
      height = mini and 0.4 or 0.7,
      border = 'none',
      {
        win = 'input',
        height = 1,
        border = { '▔', '▔', '▔', ' ', '─', '─', '─', ' ' },
        title = ' {source} {live}',
        title_pos = 'center',
      },
      {
        box = 'horizontal',
        { win = 'list', border = 'none' },
        { win = 'preview', width = 0.6, border = 'left' },
      },
    },
  }
end

function M.get_cursor()
  return {
    preview = false,
    layout = {
      relative = 'cursor',
      row = 1,
      height = 10,
      backdrop = true,
      width = 0.4,
      min_width = 80,
      border = 'none',
      box = 'vertical',
      {
        box = 'vertical',
        border = hover.border,
        title = '{source} {live}',
        title_pos = 'center',
        { win = 'input', height = 1, border = 'bottom' },
        { win = 'list', border = 'none' },
      },
    },
  }
end

function M.get_sidebar()
  return {
    preview = 'main',
    layout = {
      backdrop = false,
      width = sidebar.width,
      min_width = sidebar.width,
      height = 0,
      position = 'left',
      border = { '', '', '', 'P', '', '', '', '' },
      -- border = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' },
      wo = { winhighlight = sidebar_hl.root },
      box = 'vertical',
      {
        win = 'input',
        height = 1,
        border = true,
        -- title = '{live} {flags}',
        title = '{title} {live} {flags}',
        title_pos = 'center',
        wo = { winhighlight = sidebar_hl.input },
      },
      {
        win = 'list',
        border = 'none',
        wo = { winhighlight = sidebar_hl.list },
      },
      {
        win = 'preview',
        title = '{preview}',
        height = 0.4,
        border = 'top',
        wo = { winhighlight = sidebar_hl.preview },
      },
    },
  }
end

function M.get_right_float()
  return {
    preview = 'main',
    layout = {
      box = 'vertical',
      backdrop = false,
      row = 0,
      col = 0.99,
      width = 32,
      height = 0,
      border = 'none',
      -- border = { '█', '█', '█', '', '', '', '', '▕' },
      title_pos = 'center',
      wo = { winhighlight = sidebar_hl.root },
      {
        win = 'input',
        title = '{title} {live} {flags}',
        height = 1,
        border = 'rounded',
        wo = { winhighlight = sidebar_hl.input },
      },
      {
        win = 'list',
        border = 'none',
        wo = { winhighlight = sidebar_hl.list },
      },
      {
        win = 'preview',
        title = '{preview}',
        width = 0.6,
        border = 'none',
        wo = { winhighlight = sidebar_hl.preview },
      },
    },
  }
end

M.picker_layouts = {
  default = M.get_default(),
  cursor = M.get_cursor(),
  dropdown = M.get_dropdown(true),
  ivy = M.get_ivy(false),
  ivy_mini = M.get_ivy(true),
  sidebar = M.get_sidebar(),
  right_float = M.get_right_float(),
  vscode = { layout = { row = 0, width = 0.4, min_width = 70 } },
  select = { layout = { border = hover.border } },
  select_main = { preset = 'select', preview = 'main', hidden = {} },
}

return M
