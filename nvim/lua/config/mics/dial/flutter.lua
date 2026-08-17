local augend = require('dial.augend')

local function flutter_nullable_augend(values)
  local pattern = [[\v(\s|[<,(])\zs(]] .. table.concat(values, '|') .. [[)(\?)?]]

  return augend.user.new({
    find = require('dial.augend.common').find_pattern_regex(pattern),
    add = function(text, addend, cursor)
      dd(text)

      if text:sub(-1) == '?' then
        text = text:sub(1, -2)
      else
        text = text .. '?'
      end

      cursor = 1

      return { text = text, cursor = cursor }
    end,
  })
end

local function flutter_enum_augend_shorthand(property, values)
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

---comment
---@param opts {enum:string,property:string}
---@param values string[]
local function enum_augend(opts, values)
  return {
    full = flutter_enum_augend_full(opts.enum, values),
    shorthand = flutter_enum_augend_shorthand(opts.property, values),
  }
end

local function custom_augend()
  local M = {}

  M.font_weight = augend.user.new({
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

  M.MainAxisAlignment = enum_augend({ enum = 'MainAxisAlignment', property = 'mainAxisAlignment' }, {
    'start',
    'end',
    'center',
    'spaceBetween',
    'spaceAround',
    'spaceEvenly',
  })

  M.CrossAxisAlignment = enum_augend({ enum = 'CrossAxisAlignment', property = 'crossAxisAlignment' }, {
    'start',
    'end',
    'center',
    'stretch',
    'baseline',
  })

  M.TextAlign = enum_augend({ enum = 'TextAlign', property = 'textAlign' }, {
    'left',
    'right',
    'center',
    'justify',
    'start',
    'end',
  })

  M.MainAxisSize = enum_augend({ enum = 'MainAxisSize', property = 'mainAxisSize' }, {
    'min',
    'max',
  })

  M.TextOverflow = enum_augend({ enum = 'TextOverflow', property = 'overflow' }, {
    'clip',
    'fade',
    'ellipsis',
    'visible',
  })

  M.BoxFit = enum_augend({ enum = 'BoxFit', property = 'fit' }, {
    'fill',
    'contain',
    'cover',
    'fitWidth',
    'fitHeight',
    'none',
    'scaleDown',
  })

  M.WrapAlignment = enum_augend({ enum = 'WrapAlignment', property = 'alignment' }, {
    'start',
    'end',
    'center',
    'spaceBetween',
    'spaceAround',
    'spaceEvenly',
  })

  M.WrapCrossAlignment = enum_augend({ enum = 'WrapCrossAlignment', property = 'crossAxisAlignment' }, {
    'start',
    'center',
    'end',
  })

  M.Clip = enum_augend({ enum = 'Clip', property = 'clipBehavior' }, {
    'none',
    'hardEdge',
    'antiAlias',
    'antiAliasWithSaveLayer',
  })

  M.TextWidthBasis = enum_augend({ enum = 'TextWidthBasis', property = 'textWidthBasis' }, {
    'parent',
    'longestLine',
  })

  M.BorderStyle = enum_augend({ enum = 'BorderStyle', property = 'style' }, {
    'none',
    'solid',
  })

  M.nullable_type = flutter_nullable_augend({
    'String',
    'int',
    'double',
    'num',
    'bool',
    'dynamic',
    'Object',
    'Widget',
  })

  return M
end

return {
  custom_augend = custom_augend,
}
