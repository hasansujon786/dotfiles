return {
  'hasansujon786/yanklist.nvim',
  event = { 'CursorHold' },
  -- init = function()
  --   vim.g.yanklist_finder = 'fzf-lua'
  -- end,
  config = function()
    -- Put mappings
    keymap('n', 'p', '<Plug>(yanklist-auto-put)', { desc = 'Put the text' })
    keymap('n', 'P', '<Plug>(yanklist-auto-Put)', { desc = 'Put the text' })
    keymap('x', 'p', '<Plug>(yanklist-auto-put)gvy', { desc = 'Put the text' })
    keymap('x', 'P', '<Plug>(yanklist-auto-Put)gvy', { desc = 'Put the text' })
    -- Put last item from Yanklist
    keymap('n', '<leader>ii', '<Plug>(yanklist-last-item-put)', { desc = 'Paste from Yanklist' })
    keymap('n', '<leader>iI', '<Plug>(yanklist-last-item-Put)', { desc = 'Paste from Yanklist' })
    keymap('x', '<leader>ii', '<Plug>(yanklist-last-item-put)gvy', { desc = 'Paste from Yanklist' })
    keymap('x', '<leader>iI', '<Plug>(yanklist-last-item-Put)gvy', { desc = 'Paste from Yanklist' })
    -- Cycle through Yanklist items
    keymap('n', '[r', '<Plug>(yanklist-cycle-forward)', { desc = 'Yanklist forward' })
    keymap('n', ']r', '<Plug>(yanklist-cycle-backward)', { desc = 'Yanklist backward' })
    -- Show Yanklist
    keymap('n', '<leader>oy', '<cmd>lua require("yanklist").yanklist()<cr>', { desc = 'Show Yanklist' })
    keymap('x', '<leader>oy', '<Esc><cmd>lua require("yanklist").yanklist_visual()<cr>', { desc = 'Show Yanklist' })
  end,
}
