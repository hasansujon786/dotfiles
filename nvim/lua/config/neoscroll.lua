local neoscroll = require('neoscroll')
neoscroll.setup()
local map = {}

local ease = 'circular'
map['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '80', ease } }
map['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '80', ease } }
map['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250', ease } }
map['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '250', ease } }
map['<C-y>'] = { 'scroll', { '-0.10', 'false', '30' } }
map['<C-e>'] = { 'scroll', { '0.10', 'false', '30' } }
map['zt'] = { 'zt', { '30' } }
map['zz'] = { 'zz', { '150' } }
map['zb'] = { 'zb', { '30' } }
require('neoscroll.config').set_mappings(map)

local scroll_timer = vim.loop.new_timer()
local lines_to_scroll = 0
local cmd = vim.cmd

local function move_cursor_to_center(isCursorAboveCenter, def, callback)
  lines_to_scroll = def
  local function fooo()
    if lines_to_scroll <= 0 then
      scroll_timer:stop()
      if callback ~= nil then
        callback()
      end
      return
    end
    lines_to_scroll = lines_to_scroll - 1

    if isCursorAboveCenter then
      cmd([[norm! j]])
    else
      cmd([[norm! k]])
    end
  end

  scroll_timer:start(1, 1, vim.schedule_wrap(fooo))
end
local function scroll_to(to)
  neoscroll.scroll(to, true, 80, ease) -- defalut scroll
end

-- function Foo()
--   local isCursorAtCenter, isCursorAboveCenter, def = require('hasan.utils.ui.cursorline').cur_pos()
--   if not isCursorAtCenter then
--     moveCursonToCenter(isCursorAboveCenter, def)
--   end
-- end

keymap({ 'n', 'v' }, '<C-d>', function()
  local cursor_at_center, cursor_at_top, differ, vp_lines = require('hasan.utils.ui.cursorline').cur_pos()

  if vp_lines <= vim.wo.scroll then
    scroll_to(vim.wo.scroll)
    return
  end

  if not cursor_at_center and cursor_at_top then
    move_cursor_to_center(cursor_at_top, differ, function() scroll_to(vim.wo.scroll - differ) end)
    return
  end

  if not cursor_at_center and not cursor_at_top then
    cmd([[norm! zz]])
  end
  scroll_to(vim.wo.scroll)
end)
keymap({ 'n', 'v' }, '<C-u>', function()
  local cursor_at_center, cursor_at_top, differ, vp_lines = require('hasan.utils.ui.cursorline').cur_pos()

  if vp_lines < vim.wo.scroll then
    cmd([[norm! zz]])
    scroll_to(-vim.wo.scroll)
    return
  end

  if not cursor_at_center and not cursor_at_top then
    move_cursor_to_center(cursor_at_top, differ, function()
      cmd([[norm! zz]])
      scroll_to(-(vim.wo.scroll - differ))
    end)
    return
  end

  if not cursor_at_center and cursor_at_top then
    cmd([[norm! zz]])
  end
  scroll_to(-vim.wo.scroll)
end)
