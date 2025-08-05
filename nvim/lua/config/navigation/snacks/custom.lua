local M = {}

local function keymap_format(item, picker)
  local ret = {} ---@type snacks.picker.Highlight[]
  ---@type vim.api.keyset.get_keymap
  local k = item.item
  local a = Snacks.picker.util.align

  if package.loaded['which-key'] then
    local Icons = require('which-key.icons')
    local icon, hl = Icons.get({ keymap = k, desc = k.desc })
    if icon then
      ret[#ret + 1] = { a(icon, 3), hl }
    else
      ret[#ret + 1] = { '   ' }
    end
  end
  local lhs = Snacks.util.normkey(k.lhs)
  ret[#ret + 1] = { k.mode, 'SnacksPickerKeymapMode' }
  ret[#ret + 1] = { ' ' }
  ret[#ret + 1] = { a(lhs, 12), 'SnacksPickerKeymapLhs' }
  ret[#ret + 1] = { ' ' }

  ret[#ret + 1] = { ' ' }
  ret[#ret + 1] = { a(k.desc or '', 45) }

  local icon_nowait = picker.opts.icons.keymaps.nowait
  if k.nowait == 1 then
    ret[#ret + 1] = { icon_nowait, 'SnacksPickerKeymapNowait' }
  else
    ret[#ret + 1] = { (' '):rep(vim.api.nvim_strwidth(icon_nowait)) }
  end
  ret[#ret + 1] = { ' ' }

  if k.buffer and k.buffer > 0 then
    ret[#ret + 1] = { a('buf:' .. k.buffer, 6), 'SnacksPickerBufNr' }
  else
    ret[#ret + 1] = { a('', 6) }
  end

  return ret
end

function M.keymaps()
  Snacks.picker.keymaps({ format = keymap_format })
end

M.keymaps()

function M.search_project_todos()
  Snacks.picker.grep({
    exclude = require('core.state').project.todo.exclude or {},
    show_empty = true,
    search = require('hasan.utils.ui.qf').get_todo_pattern,
    finder = 'grep',
    format = 'file',
    live = false,
    supports_live = true,
  })
end

-- zen = {
--   on_open = function(win)
--     wezterm_zen(nil, true, { font = 0 })
--   end,
--   on_close = function(win)
--     wezterm_zen(nil, false, nil)
--   end,
-- },
-- function M.wezterm_zen(state, disable, opts)
--   local stdout = vim.loop.new_tty(1, false)
--   if disable then
--     Stdout:write(
--       -- Requires tmux setting or no effect: set-option -g allow-passthrough on
--       ('\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\'):format(
--         'ZEN_MODE',
--         vim.fn.system({ 'base64' }, tostring(opts.font))
--       )
--     )
--   else
--     stdout:write(
--       ('\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\'):format('ZEN_MODE', vim.fn.system({ 'base64' }, '-1'))
--     )
--   end
--   vim.cmd([[redraw]])
-- end

return M
