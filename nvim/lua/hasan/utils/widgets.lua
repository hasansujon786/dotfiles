local utils = require('hasan.utils')
local Input = require('nui.input')
local Menu = require('nui.menu')
local Text = require('nui.text')
local event = require('nui.utils.autocmd').event
local ui = require('hasan.core.state').ui
local async = require('plenary.async')
local M = {}

M.get_confirmation = function(opts, callback)
  if opts.use_ui_input then
    opts.prompt = opts.prompt .. ' [y/N]'
    vim.ui.input(opts, function(input)
      callback(input and input:lower() == 'y')
    end)
  else
    async.run(function()
      return vim.fn.confirm(opts.prompt, table.concat({ '&Yes', '&No' }, '\n'), 2) == 1
    end, callback)
  end
end

-- Prompts the user for input
-- @param opts {prompt,prefix,win_config}
-- @param on_confirm {function}
M.get_input = function(opts, callback)
  local min_width = 26
  local text_width = opts.default and string.len(opts.default) + 1 or min_width

  local win_config = utils.merge({
    relative = 'cursor',
    position = { row = 2, col = 0 },
    size = text_width > min_width and text_width or min_width,
    border = {
      style = ui.border.style,
      text = opts.prompt and { top = Text(opts.prompt, ui.border.highlight) },
    },
    win_options = {
      sidescrolloff = 0,
      winhighlight = 'Normal:Normal',
    },
  }, opts.win_config or {})
  opts.win_config = nil

  opts.on_submit = opts.on_submit or callback
  opts.prompt = opts.prefix
  opts.default_value = opts.default_value or opts.default
  opts.default = nil

  local input = Input(win_config, opts)
  -- mount/open the component
  input:mount()

  input:map('i', '<Esc>', input.input_props.on_close, { noremap = true })
  input:map('n', '<Esc>', input.input_props.on_close, { noremap = true })
  input:map('i', '<C-c>', input.input_props.on_close, { noremap = true })
  input:map('n', '<C-c>', input.input_props.on_close, { noremap = true })
  input:map('i', '<C-w>', '<C-o>ciw', { noremap = true })
  input:map('i', '<A-BS>', '<C-o>ciw', { noremap = true })
  -- unmount component when cursor leaves buffer
  input:on(event.BufLeave, function()
    input:unmount()
  end)
end

-- Prompts the user to pick from a list of items
-- @param items {list}
-- @param opts {prompt,win_config}
-- @param on_confirm {function}
M.get_select = function(items, opts, callback)
  local right_pad = 6
  local width = opts.min_width or 20
  local max_width = opts.max_width or 60
  local format_item = opts.format_item or function(item)
    return tostring(item.__raw_item or item)
  end

  local menu_items = {}
  for index, item in ipairs(items) do
    if type(item) ~= 'table' then
      item = { __raw_item = item }
    end
    item.index = index
    local item_text = format_item(item)
    menu_items[index] = Menu.item(item_text, item)

    -- Update width
    local len = string.len(item_text)
    if len > width then
      width = len
    end
  end

  local win_config = utils.merge({
    relative = 'editor',
    position = { row = '50%', col = '50%' },
    border = {
      -- left = opts.number and 0 or 2, right = opts.number and 3 or 2,
      padding = { top = 1, bottom = 1, left = 0, right = 0 },
      style = ui.border.style,
      highlight = ui.border.highlight,
      text = { top = opts.prompt and Text(opts.prompt) or nil, top_align = opts.prompt_align },
    },
    win_options = {
      numberwidth = 4,
      number = true,
      winhighlight = 'Normal:Normal,CursorLine:NuiMenuItem,CursorLineNr:NuiMenuItem',
    },
  }, opts.win_config or {})
  opts.prompt = nil
  opts.prompt_align = nil
  opts.win_config = nil
  opts.format_item = nil

  opts = utils.merge({
    max_width = max_width,
    min_width = (width > max_width and max_width or width) + right_pad,
    max_height = 8,
    keymap = {
      focus_next = { 'j', '<Down>', '<Tab>' },
      focus_prev = { 'k', '<Up>', '<S-Tab>' },
      close = { '<Esc>', '<C-c>', 'q' },
      submit = { '<CR>', '<Space>' },
    },
    on_close = nil,
    on_submit = opts.on_submit or callback,
  }, opts or {})
  opts.lines = menu_items

  -- mount the component
  local menu = Menu(win_config, opts)
  menu:mount()
  vim.cmd([[hi Cursor blend=100]])

  -- close menu when cursor leaves buffer
  menu:on(event.BufLeave, function()
    vim.cmd([[hi Cursor blend=0]])
    menu.menu_props.on_close()
  end, { once = true })
end

function M.use_telescope_cursor_theme_pre()
  _G.topts = require('telescope.themes').get_cursor()
end

return M
