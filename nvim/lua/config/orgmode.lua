local orgmode = require('orgmode')
-- Load custom tree-sitter grammar for org filetype
orgmode.setup_ts_grammar()
orgmode.setup({
  org_agenda_files = { '~/vimwiki/**/*' },
  org_default_notes_file = '~/vimwiki/5_inbox/refile.org',
  org_hide_leading_stars = true,
  org_hide_emphasis_markers = true,
  org_todo_keywords = { 'TODO', 'NEXT', 'WORKING', 'WAITING', '|', 'DONE', 'CANCELED' },
  org_agenda_templates = {
    m = {
      description = 'Mark file',
      template = '** %?\n  %a',
      target = '~/vimwiki/5_inbox/mark_files.org',
    },
    t = {
      description = 'Task',
      template = '** TODO %?\n  %u',
    },
    -- e = 'Event',
    -- er = {
    --   description = 'recurring',
    --   template = '** %?\n %T',
    --   headline = 'recurring',
    -- },
    -- eo = {
    --   description = 'one-time',
    --   template = '** %?\n %T',
    --   target = '~/org/calendar.org',
    --   headline = 'one-time',
    -- },
  },
})
