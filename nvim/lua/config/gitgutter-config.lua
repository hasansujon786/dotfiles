keymap('n', ']c', '<Plug>(GitGutterNextHunk)')
keymap('n', '[c', '<Plug>(GitGutterPrevHunk)')
keymap('n', '<leader>gp', '<Plug>(GitGutterPreviewHunk)')
keymap('n', '<leader>gs', '<Plug>(GitGutterStageHunk)')
keymap('n', '<leader>gr', '<Plug>(GitGutterUndoHunk)')
keymap('n', '<leader>gq', '<Cmd>GitGutterQuickFix | copen<CR>')

keymap('o', 'ih', '<Plug>(GitGutterTextObjectInnerPending)')
keymap('o', 'ah', '<Plug>(GitGutterTextObjectOuterPending)')
keymap('x', 'ih', '<Plug>(GitGutterTextObjectInnerVisual)')
keymap('x', 'ah', '<Plug>(GitGutterTextObjectOuterVisual)')
