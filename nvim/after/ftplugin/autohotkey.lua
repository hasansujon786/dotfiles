keymap('n', '<leader>v.', function()
  require('hasan.utils.file').reload_ahk()
end, { buffer = true })
