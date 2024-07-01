return {
  entry = function()
    local h = cx.active.current.hovered
    os.execute(string.format('C:\\Users\\hasan\\AppData\\Local\\Programs\\QuickLook\\QuickLook.exe "%s"', h.url))
  end,
}
