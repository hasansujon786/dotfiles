require('neogit').setup({
  disable_insert_on_commit = 'auto',
  disable_signs = false,
  disable_hint = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = true,
  auto_refresh = true,
  disable_builtin_notifications = false,
  use_magit_keybindings = false,
  commit_popup = {
    kind = 'split',
  },
  kind = 'tab',
  signs = {
    -- { CLOSED, OPENED }
    section = { '', '' },
    item = { '', '' },
    hunk = { '', '' },
  },
  integrations = {
    diffview = true,
  },
  -- Setting any section to `false` will make the section not render at all
  sections = {
    untracked = {
      folded = false,
    },
    unstaged = {
      folded = false,
    },
    staged = {
      folded = false,
    },
    stashes = {
      folded = true,
    },
    unpulled = {
      folded = true,
    },
    unmerged = {
      folded = false,
    },
    recent = {
      folded = true,
    },
  },
  -- mappings = {
  --   -- modify status buffer mappings
  --   status = {
  --     -- Adds a mapping with "B" as key that does the "BranchPopup" command
  --     ['B'] = 'BranchPopup',
  --     -- Removes the default mapping of "s"
  --     ['s'] = '',
  --   },
  -- },
})
