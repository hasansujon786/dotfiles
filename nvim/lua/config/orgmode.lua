require('orgmode').setup({
  org_agenda_files = {'~/vimwiki/org/**/*'},
  org_default_notes_file = '~/vimwiki/org/refile.org',
  org_hide_leading_stars = true,
  org_hide_emphasis_markers = true,
  org_agenda_templates = {
    m = { description = 'Bookmark', template = '* %?\n  %a', target = '~/vimwiki/org/bookmark.org' },
  }
})
