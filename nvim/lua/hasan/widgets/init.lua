local Popup = require('nui.popup')
local Input = require('nui.input')
local Menu = require('nui.menu')
local Text = require('nui.text')
local event = require('nui.utils.autocmd').event

local async = require('plenary.async')
local utils = require('hasan.utils')
local ui = require('core.state').ui

local M = {}
local anchor = { 'NW', 'NE', 'SW', 'SE' }
local map_opt = { noremap = true, nowait = true }

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

  local exit_win = function()
    on_confirm(nil)
  end
  -- cancel operation if <Esc> is pressed
  self:map('n', '<Esc>', exit_win, map_opt)
  self:map('i', '<Esc>', '<Esc>', map_opt)
  self:map('i', '<C-c>', '<Esc>', map_opt)
  -- self:map('i', '<A-BS>', '<C-o>ciw', { noremap = true })
end

---@param opts {use_ui_input:boolean,prompt:string}
---@param on_confirm fun(input)
M.get_confirmation = function(opts, on_confirm)
  if opts.use_ui_input then
    opts.prompt = opts.prompt .. ' [Y/N]'
    vim.ui.input(opts, function(input)
      on_confirm(input and input:lower() == 'y')
    end)
  else
    async.run(function()
      return vim.fn.confirm(opts.prompt, table.concat({ '&Yes', '&No' }, '\n'), 2) == 1
    end, on_confirm)
  end
end

local _input_ui
-- Prompts the user for input
---@param opts {prompt:string,default:string,prefix:string,win_config:table}
---@param on_confirm fun(input)
M.get_input = function(opts, on_confirm)
  assert(type(on_confirm) == 'function', 'missing on_confirm function')

  if _input_ui then
    -- ensure single ui.input operation
    vim.api.nvim_err_writeln('busy: another input is pending!')
    return
  end

  _input_ui = UIInput(opts, function(value)
    if _input_ui then
      _input_ui:unmount()
    end
    on_confirm(value)
    _input_ui = nil -- indicate the operation is done
  end)

  _input_ui:mount()
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
        winhighlight = 'Normal:NormalFloatFlat,FloatBorder:TabBarInputBorder',
      },
    },
  }, opts or {})

  M.get_input(opts, callback)
end

---Prompts the user to pick from a list of items
---@param items table
---@param opts SelectMenuOpts
---@param on_choice fun(item: any|nil)
M.get_select = function(items, opts, on_choice)
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
      highlight = 'Normal:NuiNormalFloat,FloatBorder:NuiFloatBorder',
      text = { top = opts.prompt and Text(opts.prompt, 'NuiBorderTitle') or nil, top_align = opts.prompt_align },
    },
    win_options = {
      numberwidth = 4,
      number = true,
      winhighlight = 'Normal:NuiNormalFloat,CursorLine:NuiMenuItem,CursorLineNr:NuiMenuItem',
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
    on_submit = on_choice,
  }, opts or {})
  opts.lines = menu_items

  -- mount the component
  local menu = Menu(win_config, opts)
  menu:mount()
  vim.cmd([[hi Cursor blend=100]])

  -- set get_char keymaps
  if opts.kind ~= nil and opts.kind == 'get_char' then
    for index, item in ipairs(items) do
      menu:map('n', item.key, function()
        vim.api.nvim_win_set_cursor(0, { index, 0 })
        menu.menu_props.on_submit()
      end, map_opt)
    end
  end

  -- close menu when cursor leaves buffer
  menu:on(event.BufLeave, function()
    vim.cmd([[hi Cursor blend=0]])
    menu.menu_props.on_close()
  end, { once = true })
end
---@class SelectMenuOpts
---@field prompt? string
---@field kind? "get_char"|nil
---@field min_width? number
---@field max_width? number
---@field prompt_align? string
---@field format_item? function
---@field win_config? nui_popup_options

M.get_notify_popup = function(opts, last_pop)
  local row = vim.o.lines - 1
  if last_pop ~= nil then
    row = last_pop.win_config.row - (last_pop.win_config.height + 2)
  end
  opts = utils.merge({
    enter = false,
    focusable = false,
    border = { style = 'rounded' },
    anchor = anchor[3],
    relative = 'editor',
    zindex = 2000,
    position = { row = row, col = '100%' },
    -- position = '80%',
    size = {
      width = 30,
      height = 1,
    },
  }, opts or {})

  return Popup(opts)
end

return M
