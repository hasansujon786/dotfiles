function Status:name()
  --------------------------------------------------
  ---- Show symlink location -----------------------
  --------------------------------------------------
  --------------------------------------------------
  ---- Show symlink location -----------------------
  --------------------------------------------------
  local h = cx.active.current.hovered
  if not h then
    return ui.Span('')
  end

  -- return ui.Span(" " .. h.name)
  local linked = ''
  if h.link_to ~= nil then
    linked = ' -> ' .. tostring(h.link_to)
  end
  return ui.Span(' ' .. h.name .. linked)
end
