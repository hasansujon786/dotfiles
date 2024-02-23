local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local Popup = require('nui.popup')
local glance = require('glance')

--------------------------------------------------
-- cursor_pointer --------------------------------
--------------------------------------------------
local cursor_pointer_pop = nil

local function create_pointer_pop()
  local cur_pos = vim.api.nvim_win_get_cursor(0)
  local opts = {
    enter = false,
    focusable = false,
    win_options = {
      sidescrolloff = 0,
      winblend = 0,
      winhighlight = '',
    },
    -- anchor = anchor[3],
    -- relative = 'cursor',
    relative = {
      type = 'buf',
      position = {
        row = cur_pos[1],
        col = 0,
      },
    },
    zindex = 21,
    position = { row = 0, col = cur_pos[2] },
    size = { width = 2, height = 1 },
  }

  return Popup(opts)
end

local function set_cursor_pointer()
  local line = NuiLine({ NuiText('', 'GlanceBorderCursor') })
  local pop = create_pointer_pop()

  local bufnr, ns_id, linenr_start = pop.bufnr, -1, 1
  line:render(bufnr, ns_id, linenr_start)
  pop:mount()

  cursor_pointer_pop = pop
  return pop
end

local function remove_cursor_pointer()
  if cursor_pointer_pop ~= nil then
    cursor_pointer_pop:unmount()
  end
end

--------------------------------------------------
-- glance_history --------------------------------
--------------------------------------------------
local offset_encoding = 'utf-16'
local glance_history = {}

local function save_history_data(results, method)
  local d = { results = results, method = method }
  table.insert(glance_history, d)
end

local open_last_history = function()
  if #glance_history == 0 then
    return vim.notify('No last data', vim.log.levels.INFO, { title = 'Glance' })
  end
  local last_history = glance_history[#glance_history]

  local parent_bufnr = vim.api.nvim_get_current_buf()
  local parent_winnr = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params()

  glance.open_history(last_history.results, parent_bufnr, parent_winnr, params, last_history.method, offset_encoding)
end

return {
  set_cursor_pointer = set_cursor_pointer,
  remove_cursor_pointer = remove_cursor_pointer,
  save_history_data = save_history_data,
  open_last_history = open_last_history,
}
