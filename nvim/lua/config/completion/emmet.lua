local ni = { 'n', 'i' }
return {
  'mattn/emmet-vim',
  lazy = true,
  init = function()
    vim.g.user_emmet_leader_key = '<C-c>'
  end,
  keys = {
    { '<C-c><C-c>', '<plug>(emmet-expand-abbr)', desc = 'Emmet: Expand abbreviation', mode = ni, silent = true },
    { '<C-c>e', '<plug>(emmet-update-tag)', desc = 'Emmet: Update tag', silent = true },
    { '<C-c>u', '<plug>(emmet-update-tag)', desc = 'Emmet: Update tag', silent = true },
    {
      '<C-c>w',
      function()
        feedkeys('V%<C-c>w')
      end,
      desc = 'Emmet: Wrap tag',
      silent = true,
    },
    { '<C-c>w', '<plug>(emmet-expand-abbr)', desc = 'Emmet: Wrap tag', mode = 'v', silent = true },
    {
      '<C-c>x',
      function()
        feedkeys('dst')
      end,
      desc = 'Emmet: Remove current tag',
      silent = true,
    },
  },
}

-- feedkeys('cst<', '')
-- imap   <C-y>;   <plug>(emmet-expand-word)
-- imap   <C-y>u   <plug>(emmet-update-tag)
-- imap   <C-y>d   <plug>(emmet-balance-tag-inward)
-- imap   <C-y>D   <plug>(emmet-balance-tag-outward)
-- imap   <C-y>n   <plug>(emmet-move-next)
-- imap   <C-y>N   <plug>(emmet-move-prev)
-- imap   <C-y>i   <plug>(emmet-image-size)
-- imap   <C-y>/   <plug>(emmet-toggle-comment)
-- imap   <C-y>j   <plug>(emmet-split-join-tag)
-- imap   <C-y>k   <plug>(emmet-remove-tag)
-- imap   <C-y>a   <plug>(emmet-anchorize-url)
-- imap   <C-y>A   <plug>(emmet-anchorize-summary)
-- imap   <C-y>m   <plug>(emmet-merge-lines)
-- imap   <C-y>c   <plug>(emmet-code-pretty)
