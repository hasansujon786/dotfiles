require('org-bullets').setup({
  symbols = {
    headlines = { '◉', '○', '✸', '✿', '♥', '' },
    checkboxes = {
      cancelled = { '', 'OrgCancelled' },
      done = { '✓', 'OrgDone' },
      todo = { ' ', 'OrgTODO' },
    },
  },
})
