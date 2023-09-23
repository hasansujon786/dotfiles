local widgets = require('hasan.utils.widgets')
local M = {}

function M.rename_current_file()
  if not vim.bo.modifiable or vim.bo.readonly then
    vim.notify('This file is readonly', vim.log.levels.WARN)
    return
  end

  require('nebulous.configs').pause(100)
  local currNameFileName = vim.fn.expand('%:t')

  local opt = { default = currNameFileName }
  widgets.get_tabbar_input(opt, function(newName)
    if newName and string.len(newName) > 0 then
      vim.cmd('Rename ' .. newName)
    end
  end)
end

function M.substitute_word()
  local isVisual = require('hasan.utils').is_visual_mode()
  local curWord = isVisual and require('hasan.utils').get_visual_selection() or vim.fn.expand('<cword>')

  local opts = { prompt = 'Substitute Word', default = curWord }
  widgets.get_input(opts, function(newWord)
    if not newWord then
      return
    end

    local cmd = isVisual and '%s/' .. curWord .. '/' .. newWord .. '/gc'
      or '%s/\\<' .. curWord .. '\\>/' .. newWord .. '/gc'

    feedkeys('<Cmd>' .. cmd .. '<CR>', 'n')
    vim.fn.setreg('z', cmd)
  end)
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
