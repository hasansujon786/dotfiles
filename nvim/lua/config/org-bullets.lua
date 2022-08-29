require('org-bullets').setup({
  show_current_line = false,
  concealcursor = true,
  indent = true,
  symbols = {
    headlines = { '◉', '○', '✸', '✿', '', '♥' },
    checkboxes = {
      cancelled = { '', 'OrgCancelled' },
      -- half = { '', 'OrgTSCheckboxHalfChecked' },
      half = { '', 'OrgTSCheckboxHalfChecked' },
      done = { '', 'OrgDone' },
      todo = { '', 'OrgTODO' },
      -- done = { '', 'OrgDone' },
      -- todo = { ' ', 'OrgTODO' },
    },
  },
})
