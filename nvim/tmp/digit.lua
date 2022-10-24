
local font = {
  0x7C, 0xC6, 0xCE, 0xDE, 0xF6, 0xE6, 0x7C, 0x00,   --  (0)
  0x30, 0x70, 0x30, 0x30, 0x30, 0x30, 0xFC, 0x00,   --  (1)
  0x78, 0xCC, 0x0C, 0x38, 0x60, 0xCC, 0xFC, 0x00,   --  (2)
  0x78, 0xCC, 0x0C, 0x38, 0x0C, 0xCC, 0x70, 0x00,   --  (3)
  0x1C, 0x3C, 0x6C, 0xCC, 0xFE, 0x0C, 0x1E, 0x00,   --  (4)
  0xFC, 0xC0, 0xF8, 0x0C, 0x0C, 0xCC, 0x78, 0x00,   --  (5)
  0x38, 0x60, 0xC0, 0xF8, 0xCC, 0xCC, 0x78, 0x00,   --  (6)
  0xFC, 0xCC, 0x0C, 0x18, 0x30, 0x30, 0x30, 0x00,   --  (7)
  0x78, 0xCC, 0xCC, 0x78, 0xCC, 0xCC, 0x78, 0x00,   --  (8)
  0x78, 0xCC, 0xCC, 0x7C, 0x0C, 0x18, 0x70, 0x00,   --  (9)
}


local function get_digit(number, pos)
  local n = 10 ^ pos
  local n1 = 10 ^ (pos - 1)
  return math.floor((number % n) / n1)
end

local function digitize(number)
  assert(type(number) == 'number')
  local len = math.floor(math.log10(number) + 1)

  local block_chars = { [0] = ' ', [1] = '▀', [2] = '▄', [3] = '█' }

  -- generate bit table
  local offset, char, row_bits, hex_val, b
  local characters = {}
  for n = 1, len do
    offset = get_digit(number, len - n + 1) * 8
    char = {}
    for row = 1, 8 do
      row_bits = {}
      hex_val = font[offset + row]
      for i = 1, 8 do
        b = bit.band(bit.rshift(hex_val, 8 - i), 1)
        row_bits[i] = b
      end
      table.insert(char, row_bits)
    end
    table.insert(characters, char)
  end

  -- generate strings
  local output = {}
  local upper, lower, combined, row_str
  for row = 1, 8, 2 do
    row_str = ' '
    for _, ch in ipairs(characters) do
      for col = 1, 8 do
        upper = ch[row][col]
        lower = ch[row + 1][col] * 2
        combined = block_chars[upper + lower]
        row_str = row_str .. combined
      end
    end
    row_str = row_str .. ' '
    table.insert(output, row_str)
  end

  return output
end
