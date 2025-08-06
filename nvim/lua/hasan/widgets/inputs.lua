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

local _show_substitute_input = function(isVisual)
  local curWord = isVisual and require('hasan.utils.visual').get_visual_selection() or vim.fn.expand('<cword>')

  vim.ui.input({
    prompt = 'Substitute Word',
    default = curWord,
    win = { style = 'input_cursor', width = math.max(#curWord + 6, 30), },
  }, function(newWord)
    if not newWord then
      return
    end

    local cmd = isVisual and '%s/' .. curWord .. '/' .. newWord .. '/gc'
      or '%s/\\<' .. curWord .. '\\>/' .. newWord .. '/gc'

    feedkeys('<Cmd>' .. cmd .. '<CR>', 'n')
    vim.fn.setreg('z', cmd)
  end)
end

function M.substitute_word()
  local isVisual = require('hasan.utils.visual').is_visual_mode()
  if isVisual then
    feedkeys('<Esc>', '')
    vim.defer_fn(function()
      _show_substitute_input(isVisual)
    end, 100)
  else
    _show_substitute_input(isVisual)
  end
end

return M
