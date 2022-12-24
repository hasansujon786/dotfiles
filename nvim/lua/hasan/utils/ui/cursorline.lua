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
  local w_start, w_current, w_end = vim.fn.line('w0'), vim.fn.line('.'), vim.fn.line('w$')
  local w_center = math.floor((w_end - w_start) / 2 + w_start)
  local isCursorAtCenter = w_center == w_current
  local isCursorAtAbove = w_center > w_current
  local def = isCursorAtCenter and 0 or isCursorAtAbove and w_center - w_current or w_current - w_center

  return isCursorAtCenter, isCursorAtAbove, def
end

return M
