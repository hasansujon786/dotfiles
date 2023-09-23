local utils = require('hasan.utils')
local Input = require('nui.input')
local Menu = require('nui.menu')
local Text = require('nui.text')
local event = require('nui.utils.autocmd').event
local ui = require('hasan.core.state').ui
local async = require('plenary.async')
local M = {}

--------------------------------------------------
-------- UIInput ---------------------------------
--------------------------------------------------
local UIInput = Input:extend('UIInput')
function UIInput:init(opts, on_confirm)
  local border_top_text = opts.prompt
  local default_value = tostring(opts.default or '')
  local prefix = tostring(opts.prefix or '')

  local win_config = utils.merge({
    relative = 'cursor',
    position = { row = 2, col = 0 },
    size = { width = math.max(20, vim.api.nvim_strwidth(default_value .. prefix) + 1) },
    border = {
      style = ui.border.style,
      text = border_top_text and { top = Text(border_top_text, ui.border.highlight) },
    },
    win_options = {
      sidescrolloff = 0,
      winhighlight = 'Normal:Normal,FloatBorder:Normal',
    },
  }, opts.win_config or {})

  UIInput.super.init(self, win_config, {
    default_value = default_value,
    prompt = prefix,
    on_close = function()
      on_confirm(nil)
    end,
    on_submit = function(value)
      on_confirm(value)
    end,
  })

  -- cancel operation if cursor leaves input
  self:on(event.BufLeave, function()
    on_confirm(nil)
  end, { once = true })

  local map_opt = { noremap = true, nowait = true }
  local exit_win = function()
    on_confirm(nil)
  end
  -- cancel operation if <Esc> is pressed
  self:map('n', '<Esc>', exit_win, map_opt)
  self:map('i', '<Esc>', exit_win, map_opt)
  self:map('i', '<C-c>', '<Esc>', map_opt)
  -- self:map('i', '<A-BS>', '<C-o>ciw', { noremap = true })
end

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

local input_ui
-- Prompts the user for input
-- @param opts {prompt,default,prefix,win_config}
-- @param on_confirm {function}
M.get_input = function(opts, callback)
  assert(type(callback) == 'function', 'missing on_confirm function')

  if input_ui then
    -- ensure single ui.input operation
    vim.api.nvim_err_writeln('busy: another input is pending!')
    return
  end

  input_ui = UIInput(opts, function(value)
    if input_ui then
      -- if it's still mounted, unmount it
      input_ui:unmount()
    end
    -- pass the input value
    callback(value)
    -- indicate the operation is done
    input_ui = nil
  end)

  input_ui:mount()
end

M.get_tabbar_input = function(opts, callback)
  opts.prompt = nil
  opts = utils.merge({
    win_config = {
      relative = 'win',
      size = 26,
      border = { style = { '', '', '', '▎', '', '', '', '▎' } },
      position = { row = -1, col = 0 },
      win_options = {
        sidescrolloff = 0,
        winhighlight = 'Normal:NormalFloatFlat,FloatBorder:KisslineWinbarRenameBorder',
      },
    },
  }, opts or {})

  M.get_input(opts, callback)
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
    min_width = math.min(width, max_width) + right_pad,
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

return M
