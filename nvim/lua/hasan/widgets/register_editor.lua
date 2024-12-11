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

  -- FIXME: text not showing
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

  local regtype = vim.fn.getregtype(char)
  if regtype == '' or regtype == nil then
    return vim.notify(string.format('"%s" reg is empty', char), vim.log.levels.WARN, { title = 'Register Editor' })
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
  vim.b[pop.bufnr].regtype = regtype

  pop:on(event.WinClosed, function()
    last_popup_window = nil
  end)

  pop:map('n', '<leader>s', function()
    if regtype == 'V' then
      feedkeys(string.format('ggVG"%sy', char))
    elseif regtype == 'v' then
      feedkeys(string.format('0ggvG$"%sy', char))
    end
  end, { desc = 'Save to register' })
  pop:map('n', 'q', function()
    pop:unmount()
  end, { desc = 'Quit from Register Editor' })

  pop:mount()

  vim.schedule(function()
    feedkeys(string.format('"%sP', char))
  end)
end

-- lua require("hasan.widgets.register_editor").open()
-- vim.fn.setreg('r', "jci'hasan mahmud")

return M
