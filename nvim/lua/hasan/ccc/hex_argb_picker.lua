local parse = require("ccc.utils.parse")
local pattern = require("ccc.utils.pattern")

local ArgbPicker = {
  pattern = {
    [=[\v%(^|[^[:keyword:]])\zs0x(\x\x)(\x\x)(\x\x)(\x\x)>]=],
    [=[\v%(^|[^[:keyword:]])\zs0x(\x\x)(\x\x)(\x\x)>]=],
  },
}

function ArgbPicker:parse_color(s, init)
  init = init or 1
  while init <= #s - 4 do
    local start_col, end_col, cap1, cap2, cap3, cap4
    for _, pat in ipairs(self.pattern) do
      start_col, end_col, cap1, cap2, cap3, cap4 = pattern.find(s, pat, init)
      if start_col then
        break
      end
    end
    if not (start_col and end_col and cap1 and cap2 and cap3) then
      return
    end
    local a = parse.hex(cap1)
    local r = parse.hex(cap2)
    local g = parse.hex(cap3)
    local b = parse.hex(cap4)
    if r and g and b then
      return start_col, end_col, { r, g, b }, a
    end
    init = end_col + 1
  end
end

return ArgbPicker
