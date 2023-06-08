local utils = require('hasan.utils')
local Input = require('nui.input')
local Menu = require('nui.menu')
local Text = require('nui.text')
local event = require('nui.utils.autocmd').event
local ui = require('core.state').ui

local M = {}

function M.telescope_cursor_theme_pre()
  _G.topts = require('telescope.themes').get_cursor()
end

function M.input(title, win_config, opts)
  local min_width = 26
  local text_width = win_config.default_value and string.len(win_config.default_value) + 1 or min_width

  win_config = utils.merge({
    relative = 'cursor',
    position = { row = 2, col = 0 },
    size = text_width > min_width and text_width or min_width,
    border = {
      style = ui.border.style,
      text = title and { top = Text(title, ui.border.text.highlight), top_align = ui.border.text.align },
    },
    win_options = {
      sidescrolloff = 0,
      winhighlight = 'Normal:Normal',
    },
  }, win_config or {})

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

function M.menu(list, opts)
  local menu_items = {}
  local width = 20
  for _, item in pairs(list) do
    table.insert(menu_items, Menu.item(item))
    local len = string.len(item) + 6
    if len > width then
      width = len
    end
  end

  opts = utils.merge({
    title = nil,
    size = #list > 8 and { height = 8, width = width } or { width = width },
    title_align = 'center',
    number = true,
    position = { row = '40%', col = '30%' },
    on_close = nil,
    on_submit = function(item)
      print('SUBMITTED', vim.inspect(item._index))
    end,
  }, opts or {})

  local menu = Menu({
    relative = 'editor',
    size = opts.size,
    position = opts.position,
    border = {
      -- left = opts.number and 0 or 2, right = opts.number and 3 or 2,
      padding = { top = 1, bottom = 1, left = 0, right = 0 },
      style = ui.border.style,
      highlight = ui.border.highlight,
      text = {
        top = opts.title and Text(opts.title) or nil,
        top_align = opts.title_align,
      },
    },
    win_options = {
      numberwidth = 4,
      number = opts.number,
      winhighlight = 'Normal:Normal,CursorLine:NuiMenuItem,CursorLineNr:NuiMenuItem',
    },
  }, {
    lines = menu_items,
    max_width = 20,
    keymap = {
      focus_next = { 'j', '<Down>', '<Tab>' },
      focus_prev = { 'k', '<Up>', '<S-Tab>' },
      close = { '<Esc>', '<C-c>', 'q' },
      submit = { '<CR>', '<Space>' },
    },
    on_close = opts.on_close,
    on_submit = opts.on_submit,
  })

  -- mount the component
  menu:mount()
  vim.cmd([[hi Cursor blend=100]])

  -- close menu when cursor leaves buffer
  menu:on(event.BufLeave, function()
    vim.cmd([[hi Cursor blend=0]])
    menu.menu_props.on_close()
  end, { once = true })
end

function M.rename_current_file()
  if not vim.bo.modifiable or vim.bo.readonly then
    vim.notify('This file is readonly', vim.log.levels.WARN)
    return
  end

  require('nebulous.configs').pause(100)
  local currNameFileName = vim.fn.expand('%:t')

  M.input(nil, {
    relative = 'win',
    size = 25,
    border = { style = { '', '', '', '▕', '', '', '', '▎' } },
    position = { row = -1, col = 0 },
    win_options = {
      sidescrolloff = 0,
      winhighlight = 'Normal:NormalFloatFlat,FloatBorder:KisslineWinbarRenameBorder',
    },
  }, {
    default_value = currNameFileName,
    on_submit = function(newName)
      if string.len(newName) > 0 then
        vim.cmd('Rename ' .. newName)
      end
    end,
  })
end

function M.substitute_word()
  local isVisual = require('hasan.utils').is_visual_mode()
  local curWord = isVisual and require('hasan.utils').get_visual_selection() or vim.fn.expand('<cword>')

  M.input('Substitute Word', {}, {
    default_value = curWord,
    on_submit = function(newWord)
      local cmd = isVisual and '%s/' .. curWord .. '/' .. newWord .. '/gc'
        or '%s/\\<' .. curWord .. '\\>/' .. newWord .. '/gc'

      feedkeys('<Cmd>' .. cmd .. '<CR>', 'n')
      vim.fn.setreg('z', cmd)
    end,
  })
end

local number_flag = 'number_cycled'
function M.cycle_numbering()
  local relativenumber = vim.wo.relativenumber
  local number = vim.wo.number

  -- Cycle through:
  -- - relativenumber + number
  if vim.deep_equal({ relativenumber, number }, { true, true }) then
    relativenumber, number = false, true
  elseif vim.deep_equal({ relativenumber, number }, { false, true }) then
    relativenumber, number = false, false
  elseif vim.deep_equal({ relativenumber, number }, { false, false }) then
    relativenumber, number = true, true
  elseif vim.deep_equal({ relativenumber, number }, { true, false }) then
    relativenumber, number = false, true
  end

  vim.wo.relativenumber = relativenumber
  vim.wo.number = number

  -- Leave a mark so that other functions can check to see if the user has
  -- overridden the settings for this window.
  vim.w[number_flag] = true
end

return M
