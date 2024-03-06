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
  config = function()
    local augend = require('dial.augend')
    require('dial.config').augends:register_group({
      -- default augends used when no group name is specified
      default = {
        augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.constant.new({ elements = { 'and', 'or' } }),
        augend.constant.new({ elements = { '&&', '||' }, word = false }),
        augend.constant.new({ elements = { '>', '<', '<=', '>=', '==', '===' }, word = false }),
        augend.hexcolor.new({ case = 'lower' }),
        augend.constant.new({
          elements = { 'number', 'string', 'boolean', 'unknown', 'any', 'void', 'null', 'undefined', 'never', 'bigint' },
          word = false,
        }),
        augend.date.new({
          pattern = '%Y/%m/%d',
          default_kind = 'day',
          only_valid = true,
          word = false,
        }),
        -- augend.paren.alias.brackets,
        augend.user.new({
          -- text-red-300
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
        }),
        augend.constant.new({
          word = true,
          elements = {
            'text-xs',
            'text-sm',
            'text-base',
            'text-lg',
            'text-xl',
            'text-2xl',
            'text-3xl',
            'text-4xl',
            'text-5xl',
            'text-6xl',
            'text-7xl',
            'text-8xl',
            'text-9xl',
          },
        }),
      },
    })
    require('dial.config').augends:on_filetype({
      markdown = {
        augend.integer.alias.decimal,
        augend.misc.alias.markdown_header,
      },
    })
  end,
}
