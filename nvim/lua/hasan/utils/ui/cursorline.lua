local api = vim.api
local M = {}

local cursorline_focus_ft = { list = true, fern = true, qf = true }
local cursorline_persist_ft = { qf = true, fern = true }
local cursorline_disable_ft = { dashboard = true, floaterm = true, TelescopePrompt = true }
local cursorline_disable_bt = { prompt = true }

M.cursorline_show = function(winid)
  local bufnr = api.nvim_win_get_buf(winid)
  local ftype = api.nvim_buf_get_option(bufnr, 'filetype')
  local btype = api.nvim_buf_get_option(bufnr, 'buftype')

  if cursorline_disable_ft[ftype] or cursorline_disable_bt[btype] then
    return
  end
  -- hightligt folded headings in org
  if ftype == 'org' then
    vim.cmd([[setl winhighlight=Folded:TextInfo]])
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
