local Popup = require('nui.popup')
local Timer = Popup:extend('Timer')
local event = require('nui.utils.autocmd').event

local running_instances = 0
local top_ofset = 1

local function seconds_to_clock(miliseconds)
  local seconds = tonumber(miliseconds) / 1000

  if seconds <= 0 then
    return '00:00:00'
  else
    local hours = string.format('%02.f', math.floor(seconds / 3600))
    local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
    local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))
    return hours .. ':' .. mins .. ':' .. secs
  end
end

local function draw_content(bufnr, text)
  local gap_width = 10 - vim.api.nvim_strwidth(text)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
    string.format(
      '%s%s%s',
      string.rep(' ', math.floor(gap_width / 2)),
      text,
      string.rep(' ', math.ceil(gap_width / 2))
    ),
  })
end

function Timer:init(popup_options)
  local options = vim.tbl_deep_extend('force', popup_options or {}, {
    border = 'double',
    relative = 'editor',
    focusable = false,
    position = { row = top_ofset, col = '100%' },
    size = { width = 10, height = 1 },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:SpecialChar',
    },
  })

  Timer.super.init(self, options)
end

function Timer:countdown(time_second, step, format_time)
  format_time = format_time or seconds_to_clock
  step = step or 1000

  self:mount()
  running_instances = running_instances + 1
  top_ofset = top_ofset + 3

  local remaining_time_ms = time_second * 1000

  draw_content(self.bufnr, format_time(remaining_time_ms))

  self:on(event.WinClosed, function()
    running_instances = running_instances - 1
    if running_instances < 1 then
      top_ofset = 1
    end
  end, { once = true })

  -- repeat on every second
  vim.fn.timer_start(step, function()
    remaining_time_ms = remaining_time_ms - step
    draw_content(self.bufnr, format_time(remaining_time_ms))

    if remaining_time_ms <= 0 then
      self:unmount()
    end
  end, { ['repeat'] = math.ceil(remaining_time_ms / step) })

  -- vim.fn.timer_start(1000, function()
  --   Time = Time + 1
  --   draw_content(SecondsToClock(Time))
  -- end, { ['repeat'] = -1 })
end

local M = {}

function M.count_down(start_time)
  local timer = Timer()

  timer:countdown(start_time)

  return timer
end

-- lua require('hasan.utils.timer').count_down(65)

-- local function foo(remaining_time)
--   return vim.fn['hasan#tt#format_abbrev_duration'](remaining_time / 1000)
-- end
return M
