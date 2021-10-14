require('orgmode').setup({
  org_agenda_files = {'~/vimwiki/**/*'},
  org_default_notes_file = '~/vimwiki/5_inbox/refile.org',
  org_hide_leading_stars = true,
  org_hide_emphasis_markers = true,
  org_agenda_templates = {
    f = { description = 'FileMark', template = '* %?\n  %a', target = '~/vimwiki/5_inbox/file-mark.org' },
  }
})
