local api = vim.api
local M = {}

local cursorline_focus_ft = { list = true, fern = true, qf = true }
local cursorline_persist_ft = { qf = true, fern = true, NvimTree = true }
local cursorline_ignore_bt = { prompt = true }
local cursorline_ignore_ft = {
  dashboard = true,
  alpha = true,
  floaterm = true,
  TelescopePrompt = true,
  ['color-picker'] = true,
}

M.cursorline_show = function(winid)
  local bufnr = api.nvim_win_get_buf(winid)
  local ftype = api.nvim_buf_get_option(bufnr, 'filetype')
  local btype = api.nvim_buf_get_option(bufnr, 'buftype')

  if cursorline_ignore_ft[ftype] or cursorline_ignore_bt[btype] then
    return
  end
  -- change hightligt to a contrasted color
  if cursorline_focus_ft[ftype] then
    vim.cmd([[setl winhighlight=CursorLine:CursorLineFocus]])
  end

  api.nvim_win_set_option(winid, 'cursorline', true)
end

M.cursorline_hide = function(winid)
  local bufnr = api.nvim_win_get_buf(winid)
  local ftype = api.nvim_buf_get_option(bufnr, 'filetype')
  -- local btype = api.nvim_buf_get_option(bufnr, 'buftype')
  if cursorline_persist_ft[ftype] then
    return
  end

  api.nvim_win_set_option(winid, 'cursorline', false)
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
