local function input_RGB_HSL()
  local ColorInput = require('ccc.input')
  local convert = require('ccc.utils.convert')

  local RgbHslInput = setmetatable({
    name = 'HSL/RGB',
    max = { 360, 1, 1, 1, 1, 1 },
    min = { 0, 0, 0, 0, 0, 0 },
    delta = { 1, 0.01, 0.01, 1 / 255, 1 / 255, 1 / 255 },
    bar_name = { 'H', 'S', 'L', 'R', 'G', 'B' },
  }, { __index = ColorInput })

  function RgbHslInput.format(n, i)
    if i == 1 then
      return ('%6d'):format(n)
    elseif i <= 3 then
      return ('%6d'):format(n * 100)
    else
      return ('%6d'):format(n * 255)
    end
  end

  function RgbHslInput.from_rgb(RGB)
    local HSL = convert.rgb2hsl(RGB)

    local R, G, B = unpack(RGB)
    local H, S, L = unpack(HSL)
    return { H, S, L, R, G, B }
  end

  function RgbHslInput.to_rgb(value)
    return { value[4], value[5], value[6] }
  end

  function RgbHslInput:_set_rgb(RGB)
    self.value[4] = RGB[1]
    self.value[5] = RGB[2]
    self.value[6] = RGB[3]
  end

  function RgbHslInput:_set_hsl(HSL)
    self.value[1] = HSL[1]
    self.value[2] = HSL[2]
    self.value[3] = HSL[3]
  end

  function RgbHslInput:callback(index, new_value)
    self.value[index] = new_value

    local v = self.value

    if index <= 3 then
      local HSL = { v[1], v[2], v[3] }
      local RGB = convert.hsl2rgb(HSL)
      self:_set_rgb(RGB)
    else
      local RGB = { v[4], v[5], v[6] }
      local HSL = convert.rgb2hsl(RGB)
      self:_set_hsl(HSL)
    end
  end

  return RgbHslInput
end

local function hex_argb_output()
  local ArgbOutput = {
    name = 'ARGB',
  }

  function ArgbOutput.str(RGB, A)
    local R = math.floor(RGB[1] * 255 + 0.5)
    local G = math.floor(RGB[2] * 255 + 0.5)
    local B = math.floor(RGB[3] * 255 + 0.5)
    if A then
      local a = math.floor(A * 255 + 0.5)
      return ('0x%02x%02x%02x%02x'):format(a, R, G, B)
    else
      return ('0xff%02x%02x%02x'):format(R, G, B)
    end
  end

  return ArgbOutput
end

local function hex_argb_picker()
  local parse = require('ccc.utils.parse')
  local pattern = require('ccc.utils.pattern')

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
end

return {
  'uga-rosa/ccc.nvim',
  lazy = true,
  cmd = 'CccPick',
  keys = {
    { '<leader>cp', '<cmd>CccPick<cr>', desc = 'Open color picker' },
    { 'cp', '<cmd>CccConvert<cr>', desc = 'Cycle color format' },
  },
  opts = function(_, opts)
    local ccc = require('ccc')
    local mapping = ccc.mapping

    local ccc_argb = hex_argb_output()
    local ccc_argb_picker = hex_argb_picker()
    local input_rgb_hsl = input_RGB_HSL()

    opts = {
      bar_char = '■',
      point_char = '∥',
      bar_len = 40,
      default_color = '#7321de',
      alpha_show = 'hide',
      preserve = true,
      save_on_quit = true,
      inputs = {
        ccc.input.hsl,
        input_rgb_hsl,
        -- ccc.input.rgb,
        -- ccc.input.oklch,
      },
      outputs = {
        ccc.output.hex,
        ccc.output.css_hsl,
        ccc.output.css_rgb,
        ccc.output.css_oklch,
        ccc_argb,
      },
      pickers = {
        ccc.picker.hex,
        ccc.picker.css_rgb,
        ccc.picker.css_hsl,
        ccc.picker.css_hwb,
        ccc.picker.css_lab,
        ccc.picker.css_lch,
        ccc.picker.css_oklab,
        ccc.picker.css_oklch,
        ccc_argb_picker,
      },
      convert = {
        { ccc.picker.hex, ccc.output.css_rgb },
        { ccc.picker.css_rgb, ccc.output.css_hsl },
        { ccc.picker.css_hsl, ccc.output.hex },
        { ccc_argb_picker, ccc_argb },
      },
      recognize = {
        pattern = {
          [ccc_argb_picker] = { ccc.input.rgb, ccc_argb },
        },
      },
      mappings = {
        ['r'] = mapping.cycle_input_mode,
        ['o'] = mapping.cycle_output_mode,
        ['$'] = mapping.set100,
        ['0'] = mapping.set0,
        ['b'] = mapping.decrease10,
        ['w'] = mapping.increase10,
        ['e'] = mapping.increase10,
        ['n'] = mapping.goto_next,
        ['p'] = mapping.goto_prev,
      },
      highlighter = {
        auto_enable = false,
        lsp = false,
      },
    }

    return opts
  end,
}
