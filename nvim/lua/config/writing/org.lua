local capture = {
  templates = {
    t = {
      description = 'Task',
      template = '* TODO %?\n  %U\n  %a',
      target = '~/org/refile.org',
    },
    w = 'Work', -- a group: w → wt, wm
    wt = {
      description = 'Work task',
      template = '* TODO %? :work:',
      target = '~/org/work.org',
      headline = 'Inbox',
    },
    wm = {
      description = 'Meeting',
      template = '* %^{Who} %^g\n  %T\n  %?',
      target = '~/org/work.org',
      olp = { 'Meetings' },
      clock_in = true,
    },
    j = {
      description = 'Journal',
      template = '* %<%H:%M> %?',
      target = '~/org/journal.org',
      datetree = true,
    },
    c = {
      description = 'Checklist item',
      type = 'checkitem',
      template = '[ ] %?',
      target = '~/org/todo.org',
      headline = 'Shopping',
    },
    l = {
      description = 'Log line',
      type = 'table-line',
      template = '| %U | %^{Amount} | %^{What} |',
      target = '~/org/log.org',
      headline = 'Expenses',
      immediate_finish = true,
    },
  },
  window = 'split', -- "split" (like Emacs) | "float" | "vsplit" | "tab" | "current"
}
return {
  'xheisenbugx/org.nvim',
  main = 'org',
  lazy = false, -- startup cost is small: heavy modules load on first use
  opts = {
    picker = 'snacks',
    org_directory = '~/org',
    agenda_files = { '~/org/**/*.org' },
    default_notes_file = '~/org/refile.org',
    ui = {
      bullets = { '◉', '○', '✸', '✿' }, -- or false
      checkboxes = { ' ', '◐', '✓' }, -- or false
      hide_emphasis_markers = true,
      indent_mode = true, -- org-indent-mode
      todo_keyword_faces = { WAITING = ':foreground #e0af68 :weight bold' },
    },
    extensions = {
      quickadd = true,
      present = true, -- enable with the defaults
      roam = { directory = '~/org' }, -- options are merged over its defaults
    },

    capture = capture,
  },
}
