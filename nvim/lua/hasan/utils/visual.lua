local M = {}

-- Visual selection
local constants = {
  visual_mode = {
    NONE = 'NONE',
    INLINE = 'INLINE',
    LINE = 'LINE',
    BLOCK = 'BLOCK',
  },
}
function Get_visual_mode(forced_mode)
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
      or Get_visual_mode(forced_mode)
  else
    visual_mode = detected_mode or Get_visual_mode(forced_mode)

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
