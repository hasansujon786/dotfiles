local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event
local M = {}

local last_popup_window = nil
M.open = function()
  if last_popup_window ~= nil then
    last_popup_window:unmount()
  end

  local msg = NuiLine({ NuiText(' >>> Press any key to edit <<< ', { hl_group = 'String' }) })
  local msg_pop = Popup({
    enter = false,
    focusable = true,
    border = { style = 'rounded', text = { top = ' Register ' } },
    win_options = { winhighlight = 'Normal:Normal' },
    position = '50%',
    size = { width = msg:width(), height = 1 },
  })
  msg:render(msg_pop.bufnr, -1, 1) -- bufnr, ns_id, linenr_start
  msg_pop:mount()
  local char = vim.fn.getcharstr()
  msg_pop:unmount()

  if char == '' or char == '' or char == nil or char == '' or char:len() ~= 1 then
    return
  end

  local pop = Popup({
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
      text = {
        top = NuiLine({ NuiText(' Register: '), NuiText(char), NuiText(' ') }),
        bottom = NuiText(' Save: <leader>s ──', 'FloatBorder'),
        bottom_align = 'right',
      },
    },
    position = '50%',
    size = { width = '60%', height = '30%' },
  })

  last_popup_window = pop
  vim.b[pop.bufnr].reg = char
  vim.b[pop.bufnr].regtype = vim.fn.getregtype(char)

  pop:map('n', '<leader>s', function()
    local regtype = vim.b[pop.bufnr].regtype
    if regtype == 'V' then
      feedkeys('ggVG"' .. char .. 'y')
    elseif regtype == 'v' then
      feedkeys('0ggvG$"' .. char .. 'y')
    end
  end)
  pop:map('n', 'q', function()
    pop:unmount()
  end)

  pop:on(event.WinClosed, function()
    last_popup_window = nil
  end)
  pop:mount()
  feedkeys('"' .. char .. 'P')
end

-- lua require("hasan.widgets.register_editor").open()
-- vim.fn.setreg('r', "jci'hasan mahmud")

return M
