keymap('n', '<leader>m', function()
  require('music.actions').ytm_toggle()
end, { desc = 'Toggle YouTube Music' })
