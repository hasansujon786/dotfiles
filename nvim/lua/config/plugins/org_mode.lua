return {
  'nvim-orgmode/orgmode',
  lazy = true,
  ft = { 'org' },
  opts = {
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
  },
  config = function(_, opts)
    local orgmode = require('orgmode')
    -- Load custom tree-sitter grammar for org filetype
    orgmode.setup_ts_grammar()
    orgmode.setup(opts)
  end,
  dependencies = {
    {
      'akinsho/org-bullets.nvim',
      opts = {
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
      },
    },
  },
}
