-- https://www.naseraleisa.com/posts/diff#file-1
return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  event = 'BufReadPost',
  opts = {
    signs = {
      add          = { text = '│', hl = 'GitSignsAdd',    numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = { text = '┊', hl = 'GitSignsChange', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = { text = '▸', hl = 'GitSignsDelete', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = { text = '▹', hl = 'GitSignsDelete', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = { text = '┊', hl = 'GitSignsChange', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      untracked    = { text = '┆', hl = 'GitSignsAdd',    numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    },
    preview_config = {
      border = require('hasan.core.state').ui.border.style,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        opts.silent = true
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'Git: Jump to hunk' })
      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'Git: Jump to hunk' })
      -- Stage Actions
      map('n', '<leader>gp', gs.preview_hunk, { desc = 'Git: Preview hunk' })
      map('n', '<leader>gs', gs.stage_hunk, { desc = 'Git: Stage hunk' })
      map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Git: Stage hunk' })
      map('n', '<leader>gr', gs.reset_hunk, { desc = 'Git: Reset hunk' })
      map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Git: Reset hunk' })
      map('n', '<leader>g.', gs.stage_buffer, { desc = 'Git: Stage buffer' })
      map('n', '<leader>gR', gs.reset_buffer, { desc = 'Git: Reset buffer' })
      map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Git: Undo last stage' })
      -- Blame Actions
      map('n', '<leader>gm', function() gs.blame_line{full=true} end, { desc = 'Git: Preview blame' })
      map('n', '<leader>gM', gs.toggle_current_line_blame, { desc = 'Git: Toggle blame line' })
      -- Diff Actions
      map('n', '<leader>gw', gs.toggle_word_diff, { desc = 'Git: Toggle word diff' })
      map('n', '<leader>gh', gs.preview_hunk_inline, { desc = 'Git: Preview hunk inline' })
      map('n', '<leader>gH', gs.toggle_deleted, { desc = 'Git: Highlight delete hunks' })
      map('n', '<leader>gL', function()
        gs.toggle_deleted()
        gs.toggle_word_diff()
      end, { desc = 'Git: Preview line diffs' })
      -- map('n', '<leader>gd', gs.diffthis)
      -- map('n', '<leader>gD', function() gs.diffthis('~') end)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      map({ 'o', 'x' }, 'ah', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  },
}
