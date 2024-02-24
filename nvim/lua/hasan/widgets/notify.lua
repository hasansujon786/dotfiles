local M = {}
local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local Widget = require('hasan.widgets')
local utils = require('hasan.utils')

local notify_popups = {}
local last_pop = nil

local LEVELS = {
  [vim.log.levels.TRACE] = 'TRACE',
  [vim.log.levels.INFO] = 'INFO',
}

local config = {
  icon = {
    TRACE = ' ',
    INFO = ' ',
  },
  hl = {
    TRACE = { title = 'NotifyTitle', border = 'NotifyBorder' },
    INFO = { title = 'NotifyTitleInfo', border = 'NotifyBorderInfo' },
  },
}

local function render_header(bufnr, opts)
  local ns_id, linenr_start = -1, 1
  local width = opts.size.width

  local time = '20:12'
  local icon = config.icon[opts.level]
  local title_gap = string.rep(' ', width + 1 - (string.len(icon) + string.len(opts.title) + string.len(time)))

  local title = NuiText(icon .. opts.title .. title_gap .. time, opts.title_hl)
  local header = NuiLine({ title })
  header:render(bufnr, ns_id, linenr_start)

  local separator = NuiLine({ NuiText(string.rep('▬', width), opts.border_hl) })
  separator:render(bufnr, ns_id, 2)
end

local function render_content(bufnr, opts, msg)
  local ns_id, linenr_start = -1, 3
  local line = NuiLine()
  line:append(msg)
  line:render(bufnr, ns_id, linenr_start)
end

local function create_notify_win(msg, opts)
  if #notify_popups == 0 then
    last_pop = nil
    notify_popups = { 1 }
  else
    table.insert(notify_popups, notify_popups[#notify_popups] + 1)
  end

  local pop = Widget.get_notify_popup(opts, last_pop)

  render_header(pop.bufnr, opts)
  render_content(pop.bufnr, opts, msg)

  -- mount/open the component
  pop:mount()
  last_pop = pop
  vim.defer_fn(function()
    table.remove(notify_popups, #notify_popups)
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
      width = 30,
      height = 3,
    },
  }, opts or {})

  create_notify_win(msg, opts)
end

_G.bar = function()
  local msg = 'Hello World Lorem animi sadf d asdf sadf asdf sdfsdfsdf asdffsdsf sdf'

  notify(msg, vim.log.levels.TRACE, { title = 'harpoon', size = { height = 5 } })
end

return M
