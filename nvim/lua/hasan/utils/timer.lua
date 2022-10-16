local Popup = require('nui.popup')
local Timer = Popup:extend('Timer')

local running_instances = 0

function Timer:init(popup_options)
  local options = vim.tbl_deep_extend('force', popup_options or {}, {
    border = 'double',
    relative = 'editor',
    focusable = true,
    position = { row = running_instances * 3 + 1, col = '100%' },
    size = { width = 10, height = 1 },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:SpecialChar',
    },
  })

  Timer.super.init(self, options)
end

function Timer:countdown(time, step, format)
  local function draw_content(text)
    local gap_width = 10 - vim.api.nvim_strwidth(text)
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, {
      string.format(
        '%s%s%s',
        string.rep(' ', math.floor(gap_width / 2)),
        text,
        string.rep(' ', math.ceil(gap_width / 2))
      ),
    })
  end

  self:mount()
  running_instances = running_instances + 1

  local remaining_time = time

  draw_content(format(remaining_time))

  vim.fn.timer_start(step, function()
    remaining_time = remaining_time - step

    draw_content(format(remaining_time))

    if remaining_time <= 0 then
      self:unmount()
      running_instances = running_instances - 1
    end
  end, { ['repeat'] = math.ceil(remaining_time / step) })
end

function _G.foo()
  local timer = Timer()

  timer:countdown(1000 * 10, 1000, function(time)
    return tostring(time / 1000) .. 's'
  end)
end
