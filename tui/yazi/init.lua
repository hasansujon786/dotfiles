Manager.render = function(self, area)
  local c = self:layout(area)

  local bar = function(c, x, y)
    if x <= 0 or x == area.w - 1 then
      return {}
    end

    return ui.Bar(
      ui.Rect({ x = x, y = math.max(0, y), w = ya.clamp(0, area.w - x, 1), h = math.min(1, area.h) }),
      ui.Bar.TOP
    )
      :symbol(c)
  end

  return ya.flat({
    -- Borders
    ui.Border(area, ui.Border.ALL):type(ui.Border.ROUNDED),
    ui.Bar(c[1]:padding(ui.Padding.y(1)), ui.Bar.RIGHT),
    ui.Bar(c[3]:padding(ui.Padding.y(1)), ui.Bar.LEFT),

    bar('┬', c[1].right - 1, c[1].y),
    bar('┴', c[1].right - 1, c[1].bottom - 1),
    bar('┬', c[2].right, c[2].y),
    bar('┴', c[2].right, c[2].bottom - 1),

    -- Parent
    Parent:render(c[1]:padding(ui.Padding.xy(1))),
    -- Current
    Current:render(c[2]:padding(c[1].w > 0 and ui.Padding.y(1) or ui.Padding(1, 0, 1, 1))),
    -- Preview
    Preview:render(c[3]:padding(ui.Padding.xy(1))),
  })
end

function Status:name()
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
