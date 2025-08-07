local Widgets = require('hasan.widgets')

local M = {}

function M.rename_current_file()
  if not vim.bo.modifiable or vim.bo.readonly then
    vim.notify('This file is readonly', vim.log.levels.WARN)
    return
  end

  require('nebulous.configs').pause(100)
  local currNameFileName = vim.fn.expand('%:t')

  local opt = { default = currNameFileName }
  Widgets.get_tabbar_input(opt, function(newName)
    if newName and string.len(newName) > 0 then
      vim.cmd('Rename ' .. newName)
    end
  end)
end

function M.substitute_word()
  local cur_word = nil
  local is_visual = require('hasan.utils.visual').is_visual_mode()

  if is_visual then
    cur_word = require('hasan.utils.visual').get_range_or_visual_text()
  else
    cur_word = vim.fn.expand('<cword>')
  end

  vim.ui.input({
    prompt = 'Substitute Word',
    default = cur_word,
    win = { style = 'input_cursor', width = math.max(#cur_word + 6, 30) },
  }, function(newWord)
    if not newWord then
      return
    end

    local cmd = is_visual and '%s/' .. cur_word .. '/' .. newWord .. '/gc'
      or '%s/\\<' .. cur_word .. '\\>/' .. newWord .. '/gc'

    feedkeys('<Cmd>' .. cmd .. '<CR>', 'n')
    vim.fn.setreg('z', cmd)
  end)
end

return M
