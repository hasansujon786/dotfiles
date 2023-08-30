-- {
--   'airblade/vim-gitgutter',
--   lazy = true,
--   event = 'BufReadPost',
--   config = function() require('config.gitgutter-config') end,
-- },
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

-- -- git-gutter =========================
-- vim.g.gitgutter_show_msg_on_hunk_jumping = 0
-- vim.g.gitgutter_map_keys = 0
-- local gitgutter_icon = '▏'
-- vim.g.gitgutter_sign_added = gitgutter_icon
-- vim.g.gitgutter_sign_modified = gitgutter_icon
-- vim.g.gitgutter_sign_removed = gitgutter_icon
-- vim.g.gitgutter_sign_removed_first_line = gitgutter_icon
-- vim.g.gitgutter_sign_removed_above_and_below = gitgutter_icon
-- vim.g.gitgutter_sign_modified_removed = gitgutter_icon
-- vim.g.gitgutter_floating_window_options = {
--   relative = 'cursor',
--   row = 1,
--   col = 0,
--   width = 10,
--   height = vim.api.nvim_eval('&previewheight'),
--   style = 'minimal',
--   border = ui.border.style,
-- }
