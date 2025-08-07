local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event

local M = {}

local feedk = vim.fn.feedkeys

local last_popup_window = nil
function M.open_editor(default_char)
  if last_popup_window ~= nil then
    last_popup_window:unmount()
  end

  local msg_pop = nil
  if not default_char then
    local msg = NuiLine({ NuiText(' >>> Press a register key to edit <<< ', { hl_group = 'String' }) })
    msg_pop = Popup({
      enter = false,
      focusable = true,
      border = { style = 'rounded', text = { top = ' Register ' } },
      win_options = { winhighlight = 'Normal:Normal' },
      position = '50%',
      size = { width = msg:width(), height = 1 },
    })
    msg:render(msg_pop.bufnr, -1, 1) -- bufnr, ns_id, linenr_start
    msg_pop:mount()
  end

  vim.schedule(function()
    local char = default_char and default_char or vim.fn.getcharstr()
    if msg_pop then
      msg_pop:unmount()
    end

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
          bottom = NuiText(' <CR> Save ', 'FloatBorder'),
          bottom_align = 'center',
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

    pop:map('n', '<CR>', function()
      if regtype == 'V' then
        feedk(string.format('ggVG"%sy', char), 'n')
      elseif regtype == 'v' then
        feedk(string.format('0ggvG$"%sy', char), 'n')
      end
    end, { desc = 'Save to register' })
    pop:map('n', 'q', function()
      pop:unmount()
    end, { desc = 'Quit from Register Editor' })

    pop:mount()

    vim.schedule(function()
      feedk(string.format('"%sP', char), 'n')
    end)
  end)
end

function M.start_recording()
  if vim.fn.reg_recording() ~= '' then
    return 'q'
  end

  vim.schedule(function()
    local char = vim.fn.getcharstr()
    if char == '' or char == '' or char == nil or char == '' or char:len() ~= 1 then
      return
    end

    local reg_text = vim.fn.getreg(char)
    if reg_text == '' or reg_text == nil then
      feedk('q' .. char, 'n')
      return
    end

    local confirm_msg = '>>> Record macro & override `%s` register? <<<'
    local choice = vim.fn.confirm(confirm_msg:format(char), table.concat({ '&Yes', '&Edit', '&No' }, '\n'), 3)
    if choice == 1 then
      feedk('q' .. char, 'n')
    elseif choice == 2 then
      M.open_editor(char)
    end
  end)
end

return M
