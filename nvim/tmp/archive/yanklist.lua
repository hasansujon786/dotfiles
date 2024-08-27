return {
  'hasansujon786/telescope-yanklist.nvim',
  enabled = false,
  event = { 'CursorHold' },
  config = function()
    -- Yanklist
    keymap('n', 'p', '<Plug>(yanklist-auto-put)')
    keymap('v', 'p', '<Plug>(yanklist-auto-put)gvy')
    keymap('n', 'P', '<Plug>(yanklist-auto-Put)')
    keymap('n', '<leader>ii', '<Plug>(yanklist-last-item-put)', { desc = 'Paste from yanklist' })
    keymap('v', '<leader>ii', '<Plug>(yanklist-last-item-put)gvy', { desc = 'Paste from yanklist' })
    keymap('n', '<leader>iI', '<Plug>(yanklist-last-item-Put)', { desc = 'Paste from yanklist' })

    -- Cycle yanklist
    keymap('n', '[r', '<Plug>(yanklist-cycle-forward)', { desc = 'Yanklist forward' })
    keymap('n', ']r', '<Plug>(yanklist-cycle-backward)', { desc = 'Yanklist backward' })

    -- Yanklist telescope
    keymap('n', '<leader>oy', '<cmd>lua require("yanklist").yanklist({initial_mode="normal"})<CR>', { desc = 'Show Yank list' })
    keymap('v', '<leader>oy', '<cmd>lua require("yanklist").yanklist({is_visual=true,initial_mode="normal"})<CR>', { desc = 'Show Yank list' })
  end,
}
