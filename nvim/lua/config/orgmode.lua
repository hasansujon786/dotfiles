-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  org_agenda_files = {'~/vimwiki/**/*'},
  org_default_notes_file = '~/vimwiki/5_inbox/refile.org',
  org_hide_leading_stars = true,
  org_hide_emphasis_markers = true,
  org_todo_keywords = {'TODO','NEXT','WORKING','WAITING', '|', 'DONE','CANCELED'},
  org_agenda_templates = {
    m = {
      description = 'Mark file',
      template = '* TODO %?\n  %a',
    },
  }
})
