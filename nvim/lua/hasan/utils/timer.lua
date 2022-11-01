local Popup = require('nui.popup')
local Timer = Popup:extend('Timer')
local event = require('nui.utils.autocmd').event

local running_instances = 0
local top_ofset = 1

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
  top_ofset = top_ofset + 3

  local remaining_time = time

  draw_content(format(remaining_time))

  vim.fn.timer_start(step, function()
    remaining_time = remaining_time - step

    draw_content(format(remaining_time))

    if remaining_time <= 0 then
      self:unmount()
    end
  end, { ['repeat'] = math.ceil(remaining_time / step) })
end

local M = {}

function M.run(start_time, formatter)
  formatter = formatter and formatter or '%ss'
  local timer = Timer()

  timer:countdown(start_time * 1000, 1000, function(remaining_time)
    return vim.fn['hasan#tt#format_abbrev_duration'](remaining_time / 1000)
    -- return string.format(formatter, remaining_time / 1000)
  end)

  timer:on(event.WinClosed, function()
    running_instances = running_instances - 1
    if running_instances < 1 then
      top_ofset = 1
    end
  end, { once = true })

  return timer
end

-- lua require('hasan.utils.timer').run(65)
return M

-- TODO: <01.11.22>
-- local Popup = require "nui.popup"
-- local Timer = Popup:extend "Timer"

-- function Timer:init(popup_options)
--   local options = vim.tbl_deep_extend("force", popup_options or {}, {
--     focusable = false,
--     position = { row = "93%", col = "100%" },
--     size = { width = 10, height = 1 },

--     border = {
--       style = "rounded",
--       text = {
--         top = "TIMER",
--         top_align = "center",
--       },
--     },
--     win_options = {
--       winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
--     },
--   })

--   Timer.super.init(self, options)
-- end

-- function SecondsToClock(_seconds)
--   local seconds = tonumber(_seconds)

--   if seconds <= 0 then
--     return "00:00:00"
--   else
--     hours = string.format("%02.f", math.floor(seconds / 3600))
--     mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
--     secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
--     return hours .. ":" .. mins .. ":" .. secs
--   end
-- end
-- function Timer:timerCount(time, step, format)
--   local function draw_content(text)
--     local gap_width = 10 - vim.api.nvim_strwidth(text)
--     vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, {
--       string.format(
--         "%s%s%s",
--         string.rep(" ", math.floor(gap_width / 2)),
--         text,
--         string.rep(" ", math.ceil(gap_width / 2))
--       ),
--     })
--   end

--   self:mount()

--   local Time = time

--   draw_content(SecondsToClock(time))
--   vim.fn.timer_start(1000, function()
--     Time = Time + 1
--     draw_content(SecondsToClock(Time))
--     -- notify "asdasd"
--   end, { ["repeat"] = -1 })
-- end

-- local timer = Timer()

-- timer:timerCount(0, 1000, function()
--   return tostring(0)
-- end)
