-- tanvirtin/vgit.nvim
return {
  'esmuellert/codediff.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    keymaps = {
      view = {
        quit = 'q', -- Close diff tab
        toggle_explorer = '<leader>b', -- Toggle explorer visibility (explorer mode only)
        diff_get = 'do', -- Get change from other buffer (like vimdiff)
        diff_put = 'dp', -- Put change to other buffer (like vimdiff)
        open_in_prev_tab = 'gf', -- Open current buffer in previous tab (or create one before)
        toggle_stage = '<leader>g.', -- Stage/unstage current file (works in explorer and diff buffers)
        stage_hunk = '<leader>gs', -- Stage hunk under cursor to git index
        unstage_hunk = '<leader>gu', -- Unstage hunk under cursor from git index
        discard_hunk = '<leader>gr', -- Discard hunk under cursor (working tree only)
        show_help = 'g?', -- Show floating window with available keymaps
      },
      explorer = {
        select = '<CR>', -- Open diff for selected file
        hover = 'K', -- Show file diff preview
        refresh = 'u', -- Refresh git status
        toggle_view_mode = 'T', -- Toggle between 'list' and 'tree' views
        stage_all = 'S', -- Stage all files
        unstage_all = 'U', -- Unstage all files
        restore = 'X', -- Discard changes (restore file)
      },
      history = {
        select = '<CR>', -- Select commit/file or toggle expand
        toggle_view_mode = 'T', -- Toggle between 'list' and 'tree' views
      },
      conflict = {
        accept_incoming = '<leader>ct', -- Accept incoming (theirs/left) change
        accept_current = '<leader>co', -- Accept current (ours/right) change
        accept_both = '<leader>cb', -- Accept both changes (incoming first)
        discard = '<leader>cx', -- Discard both, keep base
        next_conflict = ']x', -- Jump to next conflict
        prev_conflict = '[x', -- Jump to previous conflict
        diffget_incoming = '2do', -- Get hunk from incoming (left/theirs) buffer
        diffget_current = '3do', -- Get hunk from current (right/ours) buffer
      },
    },
  },
  cmd = 'CodeDiff',
}
