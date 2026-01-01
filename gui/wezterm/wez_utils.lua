local platform = require('platform')

local M = {}

function M.get_cwd_tail(tab_info)
  local pane = tab_info.active_pane
  if not pane or not pane.current_working_dir then
    return '[no cwd]'
  end

  local cwd_uri = tostring(pane.current_working_dir)

  -- This matches both Unix and Windows-style file:// URIs
  local cwd = cwd_uri:match('^file:///?(.*)')
  if not cwd then
    return '[invalid cwd]'
  end

  -- Decode percent-encoding, e.g. %20 => space
  cwd = cwd:gsub('%%(%x%x)', function(hex)
    return string.char(tonumber(hex, 16))
  end)

  -- Return only the last part (tail) of the path
  return cwd:match('([^/\\]+)/$') or cwd
end

function M.trim(s)
  return s:match('^%s*(.-)%s*$')
end

function M.tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  else
    title = tab_info.active_pane.title
  end

  title = title:gsub('/+$', '')
  return M.trim(title:match('([^/]+)$'))
end

function M.fit_to_length(text, max_length)
  local len = #text

  if len > max_length then
    return text:sub(1, max_length)
  else
    local padding = max_length - len
    local left_pad = math.floor(padding / 2)
    local right_pad = padding - left_pad
    return string.rep(' ', left_pad) .. text .. string.rep(' ', right_pad)
  end
end

--- Converts Windows backslash to forward slash
---@param path string
function M.normalize_path(path)
  return platform.is_win and path:gsub('\\', '/') or path
end

return M
