--- @since 25.2.7

local get_hovered_path = ya.sync(function(state)
  local h = cx.active.current.hovered
  if h then
    local path = tostring(h.url)
    -- if h.cha.is_dir then
    --   return path .. path_sep
    -- end
    return path
  else
    return ''
  end
end)

local M = {
  entry = function(_, _)
    local path = get_hovered_path()
    os.execute(string.format('QuickLook.exe "%s"', path))
  end,
}

return M
