local M = {}

function M.is_visual_mode()
  local mode = vim.api.nvim_get_mode().mode
  return mode == 'v' or mode == 'V' or mode == '', mode
end

function M.exit_visual_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

function M.get_visual_selection()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  local lines = vim.fn.getline(start_pos[1], end_pos[1])
  -- Add when only select in 1 line
  local plusEnd = 0
  local plusStart = 1
  if #lines == 0 then
    return ''
  elseif #lines == 1 then
    plusEnd = 1
    plusStart = 1
  end
  lines[#lines] = string.sub(lines[#lines], 0, end_pos[2] + plusEnd)
  lines[1] = string.sub(lines[1], start_pos[2] + plusStart, string.len(lines[1]))

  if type(lines) == 'string' then
    return lines
  end
  return table.concat(lines, '')
end

---Get range or visual text to use it with nvim_create_user_command
---@param range? number
function M.get_range_or_visual_text(range)
  if range == 2 then
    return require('hasan.utils.visual').get_visual_selection()
  elseif require('hasan.utils.visual').is_visual_mode() then
    local r = require('hasan.utils.visual').get_visual_region(0, true)
    return require('hasan.utils.visual').nvim_buf_get_text(0, r.start_row, r.start_col, r.end_row, r.end_col)[1]
  end
end

-- Visual selection
local constants = {
  visual_mode = {
    NONE = 'NONE',
    INLINE = 'INLINE',
    LINE = 'LINE',
    BLOCK = 'BLOCK',
  },
}
local function get_visual_mode(forced_mode)
  local mode = forced_mode or vim.api.nvim_get_mode().mode

  if mode == 'v' then
    return constants.visual_mode.INLINE
  elseif mode == 'V' then
    return constants.visual_mode.LINE
  elseif mode == '\22' then
    return constants.visual_mode.BLOCK
  end

  return constants.visual_mode.NONE
end

function M.is_same_position(a, b)
  return a[1] == b[1] and a[2] == b[2]
end

function M.get_visual_region(buffer, updated, forced_mode, detected_mode)
  buffer = buffer or 0
  local sln, eln, visual_mode

  if updated and not forced_mode then
    local spos = vim.fn.getpos('v')
    local epos = vim.fn.getpos('.')
    sln = { spos[2], spos[3] - 1 }
    eln = { epos[2], epos[3] - 1 }

    visual_mode = detected_mode
      or M.is_same_position(spos, epos) and constants.visual_mode.NONE
      or get_visual_mode(forced_mode)
  else
    visual_mode = detected_mode or get_visual_mode(forced_mode)

    if visual_mode == constants.visual_mode.INLINE then
      sln = vim.api.nvim_buf_get_mark(buffer or 0, '<')
      eln = vim.api.nvim_buf_get_mark(buffer or 0, '>')
    elseif visual_mode == constants.visual_mode.LINE then
      sln = vim.api.nvim_buf_get_mark(buffer or 0, '<')
      eln = vim.api.nvim_buf_get_mark(buffer or 0, '>')
    elseif forced_mode then
      sln = vim.api.nvim_buf_get_mark(buffer or 0, '<')
      eln = vim.api.nvim_buf_get_mark(buffer or 0, '>')
    else
      sln = vim.api.nvim_buf_get_mark(buffer or 0, '[')
      eln = vim.api.nvim_buf_get_mark(buffer or 0, ']')
    end
  end

  if visual_mode == constants.visual_mode.LINE then
    sln = { sln[1], 0 }
    eln = { eln[1], vim.fn.getline(eln[1]):len() - 1 }
  end

  -- Make sure we we change start and end if end is higher than start.
  -- This happens when we select from bottom to top or from right to left.
  local start_row = math.min(sln[1], eln[1])
  local start_col = math.min(sln[2] + 1, eln[2] + 1)
  local end_row = math.max(sln[1], eln[1])
  local end_col_1 = math.min(sln[2], vim.fn.getline(sln[1]):len()) + 1
  local end_col_2 = math.min(eln[2], vim.fn.getline(eln[1]):len()) + 1
  local end_col = math.max(end_col_1, end_col_2)

  local region = {
    mode = visual_mode,
    start_row = start_row,
    start_col = start_col,
    end_row = end_row,
    end_col = end_col,
  }

  return region
end

function M.nvim_buf_get_text(buffer, start_row, start_col, end_row, end_col)
  local lines = vim.api.nvim_buf_get_lines(buffer, start_row - 1, end_row, false)

  lines[vim.tbl_count(lines)] = string.sub(lines[vim.tbl_count(lines)], 0, end_col)
  lines[1] = string.sub(lines[1], start_col)

  return lines
end

return M
