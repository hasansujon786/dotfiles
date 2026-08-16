local function flutter_enum_augend(property, values)
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

-- local function flutter_enum_augend_full(enum, values)
--   return augend.user.new({
--     find = require('dial.augend.common').find_pattern_regex(
--       [[\v(]] .. enum .. [[\.(]] .. table.concat(values, '|') .. [[)]]
--     ),
--     add = function(text, addend, cursor)
--       local cur_index = require('hasan.utils').index_of(values, text)
--
--       local new_index = cur_index + addend
--
--       if new_index > #values then
--         new_index = 1
--       elseif new_index < 1 then
--         new_index = #values
--       end
--
--       text = values[new_index]
--       cursor = #enum + 1 + #text
--
--       return { text = text, cursor = cursor }
--     end,
--   })
-- end

function custom_augend()
  local augend = require('dial.augend')

  local M = {}

  M.tailwind_bg_text_colors = augend.user.new({
    -- text-red-400
    -- bg-blue-800
    find = require('dial.augend.common').find_pattern_regex([[\v(<(text|bg)-[a-z]+-[0-9]+)>]]),
    add = function(text, addend, cursor)
      local nums = { '50', '100', '200', '300', '400', '500', '600', '700', '800', '900', '950' }
      local inputs = vim.split(text, '-')
      local cur_index = require('hasan.utils').index_of(nums, inputs[3])

      local new_index = cur_index + addend
      if new_index > #nums then
        new_index = 1
      elseif new_index < 1 then
        new_index = #nums
      end
      inputs[3] = nums[new_index]

      text = table.concat(inputs, '-')
      cursor = #text
      return { text = text, cursor = cursor }
    end,
  })

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

  M.flutter_main_axis_alignment_sh = flutter_enum_augend('mainAxisAlignment', {
    'start',
    'end',
    'center',
    'spaceBetween',
    'spaceAround',
    'spaceEvenly',
  })

  M.flutter_cross_axis_alignment_sh = flutter_enum_augend('crossAxisAlignment', {
    'start',
    'end',
    'center',
    'stretch',
    'baseline',
  })

  M.flutter_text_align_sh = flutter_enum_augend('textAlign', {
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

local nx = { 'n', 'x' }
return {
  'monaqa/dial.nvim',
  lazy = true,
  keys = {
    { '<Plug>(dial-increment)', mode = nx },
    { '<Plug>(dial-decrement)', mode = nx },
    { 'g<Plug>(dial-increment)', mode = nx },
    { 'g<Plug>(dial-decrement)', mode = nx },
  },
  init = function()
    keymap(nx, '<C-a>', '<Plug>(dial-increment)')
    keymap(nx, '<C-x>', '<Plug>(dial-decrement)')
    keymap(nx, 'g<C-a>', '<Plug>(dial-increment)')
    keymap(nx, 'g<C-x>', '<Plug>(dial-decrement)')
  end,
  config = function()
    local augend = require('dial.augend')
    local toggle = function(...)
      return require('dial.augend').constant.new(...)
    end

    local aug = custom_augend()

    require('dial.config').augends:register_group({
      -- Default augends used when no group name is specified
      default = {
        augend.integer.alias.decimal, -- non-negative decimal number (0, 1, 2, 3, ...)
        augend.integer.alias.hex, -- non-negative hex number (0x01, 0x1a1f, etc.)
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.constant.alias.en_weekday_full,
        toggle({ elements = { 'let', 'const' } }),
        toggle({ elements = { 'and', 'or' } }),
        toggle({ elements = { '&&', '||' }, word = false }),
        toggle({ elements = { '>', '<' }, word = false }),
        toggle({ elements = { '!==', '===' }, word = false }),
        toggle({ elements = { '!=', '==' }, word = false }),
        augend.hexcolor.new({ case = 'lower' }),
        toggle({
          elements = { 'number', 'string', 'boolean', 'unknown', 'any', 'void', 'null', 'undefined', 'never', 'bigint' },
          word = false,
        }),
        toggle({
          elements = { 'GET', 'POST', 'PUT', 'PATCH', 'DELETE' },
          word = false,
        }),
        toggle({
          elements = { 'TODO:', 'DONE:', 'INFO:', 'FIXME:', 'BUG:', 'FIXIT:', 'ISSUE:', 'OPTIM:', 'OPTIMIZE:' },
          word = false,
        }),
        augend.date.new({
          pattern = '%Y/%m/%d',
          default_kind = 'day',
          only_valid = true,
          word = false,
        }),
        -- augend.paren.alias.brackets,
        aug.tailwind_bg_text_colors,
        aug.flutter_font_weight,
        aug.flutter_main_axis_alignment_sh,
        aug.flutter_cross_axis_alignment_sh,
        aug.flutter_text_align_sh,

        aug.flutter_main_axis_alignment,
        aug.flutter_cross_axis_alignment,
        aug.flutter_text_align,

        -- toggle({
        --   word = true,
        --   elements = {
        --     'text-xs',
        --     'text-sm',
        --     'text-base',
        --     'text-lg',
        --     'text-xl',
        --     'text-2xl',
        --     'text-3xl',
        --     'text-4xl',
        --     'text-5xl',
        --     'text-6xl',
        --     'text-7xl',
        --     'text-8xl',
        --     'text-9xl',
        --   },
        -- }),
      },
    })
    require('dial.config').augends:on_filetype({
      markdown = {
        augend.integer.alias.decimal,
        augend.misc.alias.markdown_header,
      },
    })
  end,
  -- dependencies = {
  --   {
  --     'hasansujon786/tailwindcss-dial.nvim',
  --     opts = {
  --       -- group = "default", -- optional, defaults to "default"
  --       ft = { 'typescript', 'typescriptreact', 'tsx', 'vue' }, -- optional
  --     },
  --   },
  -- },
}
