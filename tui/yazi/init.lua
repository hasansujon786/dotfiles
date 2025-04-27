function Status:name()
  local h = cx.active.current.hovered
  if not h then
    return ui.Span('')
  end

  --------------------------------------------------
  ---- Show symlink location -----------------------
  --------------------------------------------------
  -- return ui.Span(" " .. h.name)
  local linked = ''
  if h.link_to ~= nil then
    linked = ' -> ' .. tostring(h.link_to)
  end
  return ui.Span(' ' .. h.name .. linked)
end

local bookmarks = {}
local is_windows = ya.target_family() == 'windows'
local path_sep = package.config:sub(1, 1)
local home_path = is_windows and os.getenv('USERPROFILE') or os.getenv('HOME')
table.insert(bookmarks, {
  tag = 'Desktop',
  path = home_path .. path_sep .. 'Desktop' .. path_sep,
  key = 'd',
})
require('yamb'):setup({ bookmarks = bookmarks })
