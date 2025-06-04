-- https://www.naseraleisa.com/posts/diff#file-1
local function next_hunk()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    package.loaded.gitsigns.nav_hunk('next')
  end)
  return '<Ignore>'
end
local function prev_hunk()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    package.loaded.gitsigns.nav_hunk('prev')
  end)
  return '<Ignore>'
end

return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  commit = '5f1b1e2',
  event = 'BufReadPost',
  opts = {
    signs_staged_enable = true,
    signs = {
      add          = { text = '│', },
      change       = { text = '┊', },
      delete       = { text = '▸', },
      topdelete    = { text = '▹', },
      changedelete = { text = '┊', },
      untracked    = { text = '┆', },
    },
    signs_staged = {
      add          = { text = '│', },
      change       = { text = '│', },
      delete       = { text = '▸', },
      topdelete    = { text = '▹', },
      changedelete = { text = '│', },
      untracked    = { text = '┆', },
    },
    preview_config = {
      border = require('core.state').ui.border.style,
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
      map('n', ']c', next_hunk, { expr = true, desc = 'Git: Jump to hunk' })
      map('n', '[c', prev_hunk, { expr = true, desc = 'Git: Jump to hunk' })
      map('n', ']x', '<cmd>Gitsigns nav_hunk next target=staged<cr>', { desc = 'Git: Jump to hunk' })
      map('n', '[x', '<cmd>Gitsigns nav_hunk prev target=staged<cr>', { desc = 'Git: Jump to hunk' })
      -- Stage Actions
      map('n', '<leader>gp', gs.preview_hunk, { desc = 'Git: Preview hunk' })
      map('n', '<leader>gs', gs.stage_hunk, { desc = 'Git: Stage hunk' })
      map('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Git: Stage hunk' })
      map('n', '<leader>gr', gs.reset_hunk, { desc = 'Git: Reset hunk' })
      map('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Git: Reset hunk' })
      map('n', '<leader>g.', '<cmd>w<cr><cmd>lua require("gitsigns").stage_buffer()<cr>', { desc = 'Git: Stage buffer' })
      map('n', '<leader>gR', gs.reset_buffer, { desc = 'Git: Reset buffer' })
      map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Git: Undo last stage' })
      -- Blame Actions
      map('n', '<leader>gm', function() gs.blame_line{full=true} end, { desc = 'Git: Preview blame' })
      map('n', '<leader>gM', gs.toggle_current_line_blame, { desc = 'Git: Toggle blame line' })
      -- Diff Actions
      map('n', '<leader>gh', gs.preview_hunk_inline, { desc = 'Git: Preview hunk inline' })
      map('n', '<leader>gH', gs.toggle_deleted, { desc = 'Git: Highlight delete hunks' })
      map('n', '<leader>gW', gs.toggle_word_diff, { desc = 'Git: Toggle word diff' })
      -- end, { desc = 'Git: Preview line diffs' })
      -- map('n', '<leader>gd', gs.diffthis)
      -- map('n', '<leader>gD', function() gs.diffthis('~') end)

      -- Text object
      map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<CR>')
      map({ 'o', 'x' }, 'ah', '<cmd>Gitsigns select_hunk<CR>')
    end,
  },
  config_path = function (_, opts)
    require('gitsigns').setup(opts)
  end
}
