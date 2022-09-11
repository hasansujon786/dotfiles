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

return M
