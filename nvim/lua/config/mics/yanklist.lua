return {
  'hasansujon786/telescope-yanklist.nvim',
  event = { 'CursorHold' },
  config = function()
    -- Yanklist
    keymap('n', 'p', '<Plug>(yanklist-auto-put)')
    keymap('x', 'p', '<Plug>(yanklist-auto-put)gvy')
    keymap('n', 'P', '<Plug>(yanklist-auto-Put)')
    keymap('n', '<leader>ii', '<Plug>(yanklist-last-item-put)', { desc = 'Paste from yanklist' })
    keymap('x', '<leader>ii', '<Plug>(yanklist-last-item-put)gvy', { desc = 'Paste from yanklist' })
    keymap('n', '<leader>iI', '<Plug>(yanklist-last-item-Put)', { desc = 'Paste from yanklist' })

    -- Cycle yanklist
    keymap('n', '[r', '<Plug>(yanklist-cycle-forward)', { desc = 'Yanklist forward' })
    keymap('n', ']r', '<Plug>(yanklist-cycle-backward)', { desc = 'Yanklist backward' })

    -- Yanklist telescope {initial_mode="normal"}
    local opts = { desc = 'Show Yank list' }
    keymap('n', '<leader>oy', '<cmd>lua require("yanklist").yanklist()<CR>', opts)
    keymap('x', '<leader>oy', '<Esc><cmd>lua require("yanklist").yanklist({is_visual=true})<CR>', opts)
  end,
}
