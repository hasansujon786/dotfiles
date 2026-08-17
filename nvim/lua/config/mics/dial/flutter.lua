local function flutter_enum_augend_shorthand(property, values)
  local augend = require('dial.augend')
  local pattern = string.format([[\v(%s:\s*\.)\zs(%s)]], property, table.concat(values, '|'))

  return augend.user.new({
    find = require('dial.augend.common').find_pattern_regex(pattern),
    add = function(text, addend, cursor)
      local cur_index = require('hasan.utils').index_of(values, text)
      local new_index = cur_index + addend

      if new_index > #values then
        new_index = 1
      elseif new_index < 1 then
        new_index = #values
      end

      text = values[new_index]
      cursor = #text

      return { text = text, cursor = cursor }
    end,
  })
end

local function flutter_enum_augend_full(enum, values)
  local augend = require('dial.augend')
  return augend.user.new({
    find = require('dial.augend.common').find_pattern_regex(
      [[\v(]] .. enum .. [[\.)\zs(]] .. table.concat(values, '|') .. [[)]]
    ),
    add = function(text, addend, cursor)
      local cur_index = require('hasan.utils').index_of(values, text)

      local new_index = cur_index + addend

      if new_index > #values then
        new_index = 1
      elseif new_index < 1 then
        new_index = #values
      end

      text = values[new_index]
      cursor = #text

      return { text = text, cursor = cursor }
    end,
  })
end

function custom_augend()
  local augend = require('dial.augend')

  local M = {}

  M.flutter_font_weight = augend.user.new({
    -- FontWeight.w100
    find = require('dial.augend.common').find_pattern_regex([[\v(\.(w[1-9]00|normal|bold))]]),
    -- Toggle only between normal and bold.
    add = function(text, addend, cursor)
      if text == '.normal' or text == '.bold' then
        text = text == '.normal' and '.bold' or '.normal'
        cursor = #text

        return { text = text, cursor = cursor }
      end

      local weights = {
        'w100',
        'w200',
        'w300',
        'w400',
        'w500',
        'w600',
        'w700',
        'w800',
        'w900',
      }

      local current = text:sub(2) -- remove "."
      local cur_index = require('hasan.utils').index_of(weights, current)

      local new_index = cur_index + addend

      if new_index > #weights then
        new_index = 1
      elseif new_index < 1 then
        new_index = #weights
      end

      text = '.' .. weights[new_index]
      cursor = #text

      return { text = text, cursor = cursor }
    end,
  })

  M.flutter_main_axis_alignment_sh = flutter_enum_augend_shorthand('mainAxisAlignment', {
    'start',
    'end',
    'center',
    'spaceBetween',
    'spaceAround',
    'spaceEvenly',
  })

  M.flutter_cross_axis_alignment_sh = flutter_enum_augend_shorthand('crossAxisAlignment', {
    'start',
    'end',
    'center',
    'stretch',
    'baseline',
  })

  M.flutter_text_align_sh = flutter_enum_augend_shorthand('textAlign', {
    'left',
    'right',
    'center',
    'justify',
    'start',
    'end',
  })

  M.flutter_main_axis_alignment = flutter_enum_augend_full('MainAxisAlignment', {
    'start',
    'end',
    'center',
    'spaceBetween',
    'spaceAround',
    'spaceEvenly',
  })

  M.flutter_cross_axis_alignment = flutter_enum_augend_full('CrossAxisAlignment', {
    'start',
    'end',
    'center',
    'stretch',
    'baseline',
  })

  M.flutter_text_align = flutter_enum_augend_full('TextAlign', {
    'left',
    'right',
    'center',
    'justify',
    'start',
    'end',
  })

  return M
end

return {
  custom_augend = custom_augend,
}
