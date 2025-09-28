local M = {}

function M.rename_current_file()
  if not vim.bo.modifiable or vim.bo.readonly then
    vim.notify('This file is readonly', vim.log.levels.WARN)
    return
  end

  local currNameFileName = vim.fn.expand('%:t')

  local opt = { default = currNameFileName }
  require('hasan.widgets').get_tabbar_input(opt, function(newName)
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

  if not cur_word or cur_word == '' then
    return
  end

  local hl_group = require('hasan.utils.hl').get_active_hl_at_cursor()
  local win_hl = ('NormalFloat:%s'):format(hl_group)

  vim.ui.input({
    prompt = 'Substitute Word',
    default = cur_word,
    win = {
      style = 'input_cursor',
      width = math.max(#cur_word + 6, 30),
      wo = { winhighlight = win_hl },
    },
  }, function(new_word)
    if not new_word or new_word == cur_word then
      return
    end

    local cmd = is_visual and '%s/' .. cur_word .. '/' .. new_word .. '/gc'
      or '%s/\\<' .. cur_word .. '\\>/' .. new_word .. '/gc'

    feedkeys('<Cmd>' .. cmd .. '<CR>', 'n')
    vim.fn.setreg('z', cmd)
  end)
end

return M
