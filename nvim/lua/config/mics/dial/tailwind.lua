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

  return M
end

return {
  custom_augend = custom_augend,
}
