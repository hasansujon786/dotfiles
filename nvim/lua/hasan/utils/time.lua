local M = {}
-- '2024-10-18T17:07:56.051Z'
function M.parse_time(date_str)
  -- Extract date and time components from ISO 8601 string
  local year, month, day, hour, min, sec = date_str:match('(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)')
  year, month, day, hour, min, sec =
    tonumber(year), tonumber(month), tonumber(day), tonumber(hour), tonumber(min), tonumber(sec)

  -- Create a Lua time table
  local time_table = { year = year, month = month, day = day, hour = hour, min = min, sec = sec }

  -- Convert to a Unix timestamp
  local target_timestamp = os.time(time_table)

  -- Get the current time's Unix timestamp
  local current_timestamp = os.time()

  -- Calculate the difference in seconds
  local diff_seconds = target_timestamp - current_timestamp

  -- Function to convert seconds into a relative time description
  local function relative_time(seconds)
    local abs_seconds = math.abs(seconds)

    if abs_seconds < 60 then
      return abs_seconds .. ' seconds ' .. (seconds < 0 and 'ago' or 'from now')
    elseif abs_seconds < 3600 then
      local minutes = math.floor(abs_seconds / 60)
      return minutes .. ' minutes ' .. (seconds < 0 and 'ago' or 'from now')
    elseif abs_seconds < 86400 then
      local hours = math.floor(abs_seconds / 3600)
      return hours .. ' hours ' .. (seconds < 0 and 'ago' or 'from now')
    else
      local days = math.floor(abs_seconds / 86400)
      return days .. ' days ' .. (seconds < 0 and 'ago' or 'from now')
    end
  end

  -- Print the relative time
  local formatted_time = os.date('%A,%B %d,%Y %I:%M:%S %p', target_timestamp)
  notify('[' .. formatted_time .. ']', vim.log.levels.INFO, { title = relative_time(diff_seconds) })
end

return M
