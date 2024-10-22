return {
  'hasansujon786/telescope-yanklist.nvim',
  event = { 'CursorHold' },
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

    local opt = {
      attach_mappings = function(_, map)
        map({ 'n', 'i' }, '<tab>', require('telescope.actions').move_selection_previous)
        map({ 'n', 'i' }, '<s-tab>', require('telescope.actions').move_selection_next)
        return true
      end,
    }

    -- Show Yanklist
    keymap('n', '<leader>oy', function()
      require('yanklist').yanklist(opt)
    end, { desc = 'Show Yanklist' })
    keymap('x', '<leader>oy', function()
      require('yanklist').yanklist_visual(opt)
    end, { desc = 'Show Yanklist' })
  end,
}
