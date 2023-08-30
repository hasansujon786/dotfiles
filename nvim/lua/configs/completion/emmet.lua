return {
  'mattn/emmet-vim',
  config = function()
    keymap('i', '<C-c>', '<nop>')
    keymap({ 'n', 'i' }, '<C-c><C-c>', '<plug>(emmet-expand-abbr)')
    keymap('n', '<C-c>e', function()
      feedkeys('cst<', '')
    end)
    keymap('n', '<C-c>w', function()
      feedkeys('V%<C-c>,', '')
    end)
    keymap('v', '<C-c>w', '<plug>(emmet-expand-abbr)')

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
  end,
}
