local api = vim.api
local M = {}

local use_vivid_hl_ftype = { list = true, fern = true, qf = true }
local force_persist_ft = {
  qf = true,
  Glance = true,
  fern = true,
  NvimTree = true,
  DiffviewFiles = true,
  Outline = true,
  flutterToolsOutline = true,
  DiffviewFileHistory = true,
  ['neo-tree'] = true,
  tsplayground = true,
}
local force_hide_btype = { prompt = true }
local force_hide_ftype = {
  dashboard = true,
  alpha = true,
  floaterm = true,
  TelescopePrompt = true,
  ['color-picker'] = true,
}

M.cursorline_show = function(winid)
  local default_vivid_cl = 'CursorLine:CursorLineFocus'
  local buf = api.nvim_win_get_buf(winid)
  local ftype = api.nvim_get_option_value('filetype', { buf = buf })
  local btype = api.nvim_get_option_value('buftype', { buf = buf })

  if force_hide_ftype[ftype] or force_hide_btype[btype] then
    return
  end
  -- change hightligt to a contrasted color
  local vivid_hl_value = use_vivid_hl_ftype[ftype]
  if vivid_hl_value then
    vim.wo.winhighlight = type(vivid_hl_value) == 'string' and vivid_hl_value or default_vivid_cl
  end

  api.nvim_set_option_value('cursorline', true, { win = winid })
end

M.cursorline_hide = function(winid)
  local buf = api.nvim_win_get_buf(winid)
  local ftype = api.nvim_get_option_value('filetype', { buf = buf })

  if force_persist_ft[ftype] then
    return
  end

  api.nvim_set_option_value('cursorline', false, { win = winid })
end

M.cur_pos = function()
  local line_start, line_current, line_end = vim.fn.line('w0'), vim.fn.line('.'), vim.fn.line('w$')
  local viewport_lines = line_end - line_start
  local line_center = math.floor(viewport_lines / 2 + line_start)
  local cursor_at_center = line_center == line_current
  local cursor_at_top = line_center > line_current
  local differ_from_center = cursor_at_center and 0
    or cursor_at_top and line_center - line_current
    or line_current - line_center

  return cursor_at_center, cursor_at_top, differ_from_center, viewport_lines
end

return M
