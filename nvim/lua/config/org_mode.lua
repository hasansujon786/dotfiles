local function loadOrgMode(key)
  return function()
    if package.loaded['nvim-treesitter'] == nil then
      vim.cmd([[Lazy load nvim-treesitter]])
    end
    vim.cmd([[Lazy load orgmode]])
    vim.defer_fn(function()
      feedkeys(key)
    end, 0)
  end
end

return {
  'nvim-orgmode/orgmode',
  lazy = true,
  ft = { 'org' },
  keys = {
    -- { '<leader>e', '<cmd>lua require("hasan.org").toggle_org_float()<CR>', desc = 'Toggle org float' },
    { '<leader>oh', '<cmd>lua require("hasan.org").open_org_home("-tabedit")<CR>', desc = 'Open org home' },

    { '<leader>oa', loadOrgMode('<space>oa'), desc = 'org agenda' },
    { '<leader>oc', loadOrgMode('<space>oc'), desc = 'org capture' },

    { '<leader>/o', '<cmd>Telescope live_grep cwd=C:\\Users\\hasan\\vimwiki<CR>', desc = 'Grep org text' },
    { '<leader>/w', '<cmd>Telescope find_files cwd=C:\\Users\\hasan\\vimwiki<CR>', desc = 'Search org files' },
    { '<leader>w/', '<cmd>Telescope find_files cwd=C:\\Users\\hasan\\vimwiki<CR>', desc = 'Search org files' },
  },
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
