local M = {}
local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local Widget = require('hasan.widgets')
local utils = require('hasan.utils')
local event = require('nui.utils.autocmd').event

local notify_popups = {}
local last_pop = nil

local LEVELS = {
  [vim.log.levels.TRACE] = 'TRACE', -- 0
  [vim.log.levels.INFO] = 'INFO', -- 2
}

local config = {
  icon = {
    TRACE = ' ',
    INFO = ' ',
  },
  hl = {
    TRACE = {
      title = 'NotifyTitle',
      border = 'NotifyBorder',
    },
    INFO = {
      title = 'NotifyTitleInfo',
      border = 'NotifyBorderInfo',
    },
  },
}

local function format_content(msg)
  local max_lenght = 0
  local lines = {}
  for line in msg:gmatch('[^\r\n]+') do
    local line_len = string.len(line)
    if line_len > max_lenght then
      max_lenght = line_len
    end
    table.insert(lines, line)
  end
  return lines, max_lenght
end

local function render_header(bufnr, opts)
  local ns_id, linenr_start = -1, 1
  local width = opts.size.width
  local icon = config.icon[opts.level]

  local time = NuiText(os.date('%I:%M:%p'), opts.title_hl)
  local title = NuiText(icon .. opts.title, opts.title_hl)
  local header_gap = NuiText(string.rep(' ', width - (title:width() + time:width())))

  local header = NuiLine({ title, header_gap, time })
  header:render(bufnr, ns_id, linenr_start)

  local separator = NuiLine({ NuiText(string.rep('▬', width), opts.border_hl) })
  separator:render(bufnr, ns_id, 2)
end

local function render_content(bufnr, _, msg_lines)
  local linenr_start = 3
  vim.api.nvim_buf_set_lines(bufnr, linenr_start, linenr_start, false, msg_lines)
end

local function create_notify_win(msg_lines, opts)
  if #notify_popups == 0 then
    last_pop = nil
    notify_popups = { 1 }
  else
    table.insert(notify_popups, notify_popups[#notify_popups] + 1)
  end

  local pop = Widget.get_notify_popup(opts, last_pop)
  vim.api.nvim_set_option_value('filetype', 'notify-popup', { buf = pop.bufnr })

  render_header(pop.bufnr, opts)
  render_content(pop.bufnr, opts, msg_lines)

  -- mount/open the component
  pop:mount()
  last_pop = pop

  pop:on({ event.WinClosed }, function()
    table.remove(notify_popups, #notify_popups)
  end, { once = true })
  vim.defer_fn(function()
    pop:unmount()
  end, 3000)
end

---@param msg string Content of the notification to show to the user.
---@param level integer|nil One of the values from |vim.log.levels|.
---@param opts table|nil Optional parameters. Unused by default.
function M.notify(msg, level, opts) -- luacheck: no unused args
  if msg == nil then
    return
  end
  local _level = LEVELS[level] or LEVELS[vim.log.levels.TRACE]
  local hls = config.hl[_level]
  local whl = 'Normal:Normal,FloatBorder:' .. hls.border

  local height = 2
  local width = 30

  local msg_lines, max_lenght = format_content(msg)
  height = height + #msg_lines
  if max_lenght > width then
    width = max_lenght
  end

  opts = utils.merge({
    level = _level,
    title = '',
    title_hl = hls.title,
    border_hl = hls.border,
    border = { style = 'rounded' },
    win_options = {
      winhighlight = whl,
      wrap = true,
      -- showbreak = '',
    },
    size = {
      width = width,
      height = height,
    },
  }, opts or {})

  create_notify_win(msg_lines, opts)
end

_G.bar = function()
  local msg = 'Hello World Lorem animi\nsadf d asdf sadf asdf sdfsdfsdf asdffsdsf sdf'

  notify(msg, vim.log.levels.TRACE, { title = 'harpoon' })
end

return M
