local M = {}
local limit = 31
local fname_fmt1, fname_fmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
local valid_fmt = '%s │%5d:%-3d│%s %s'
local fn = vim.fn

M.qftf = function(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = M.valid_qf_fname(e.bufnr)
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = valid_fmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end


M.valid_qf_fname = function(bufnr)
  local fname = fn.bufname(bufnr)
  if fname == '' then
    fname = '[No Name]'
  else
    fname = fname:gsub('^' .. vim.env.HOME, '~')
  end
  -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
  if #fname <= limit then
    fname = fname_fmt1:format(fname)
  else
    fname = fname_fmt2:format(fname:sub(1 - limit))
  end
  return fname
end

return M
