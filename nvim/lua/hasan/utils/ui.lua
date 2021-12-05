local utils = require('hasan.utils')
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local M = {}

M.input = function(title, options)
  local width = string.len(options.default_value) + 10

  local popup_options = {
    relative = 'cursor',
    position = {
      row = 1,
      col = 0,
    },
    size =  utils.get_default(options.size, width > 25 and width or 25) ,
    border = {
      style = 'rounded',
      highlight = 'FloatBorder',
      text = {
        top = title,
        top_align = 'center',
      },
    },
    win_options = {
      -- winblend = 5,
      winhighlight = 'Normal:Normal',
    },
  }

  local input = Input(popup_options, options)
  -- mount/open the component
  input:mount()

  input:map('i', '<Esc>', input.input_props.on_close, { noremap = true })
  input:map('n', '<Esc>', input.input_props.on_close, { noremap = true })
  input:map('i', '<C-c>', input.input_props.on_close, { noremap = true })
  input:map('n', '<C-c>', input.input_props.on_close, { noremap = true })

  -- unmount component when cursor leaves buffer
  input:on(event.BufLeave, function()
    input:unmount()
  end)
end

M.rename_current_file = function ()
  local currNameFileName = vim.fn.expand('%:t')

  M.input('Rename File', {
    prompt = '> ',
    default_value = currNameFileName,
    on_submit = function(newName)
      if string.len(newName) > 0 then
        vim.cmd('Rename '.. newName)
      end
    end,
  })
end

M.substitute_word = function (isVisual)
  local curWord = isVisual and vim.fn['hasan#utils#get_visual_selection']() or vim.fn.expand('<cword>')

  M.input('Substitute Word', {
    default_value = curWord,
    on_submit = function(newWord)
      local cmd = isVisual and '%s/'..curWord..'/'..newWord..'/gc' or '%s/\\<'..curWord..'\\>/'..newWord..'/gc'

      vim.fn['hasan#utils#feedkeys'](':<C-u>'..cmd..'<CR>', 'n')
      vim.fn.setreg('z', cmd)
    end,
  })
end

return M
-- require('hasan.utils.ui').rename_current_file()
