local function load_treesitter()
  if package.loaded['nvim-treesitter'] == nil then
    vim.cmd([[Lazy load nvim-treesitter]])
  end
end
local function loadOrgMode(key)
  return function()
    load_treesitter()
    vim.cmd([[Lazy load orgmode]])
    vim.defer_fn(function()
      feedkeys(key)
    end, 0)
  end
end

return {
  {
    'chipsenkbeil/org-roam.nvim',
    module = 'org-roam',
    keys = { { '<leader>nf' }, { '<leader>nc' } },
    ft = { 'org' },
    lazy = true,
    dependencies = { 'nvim-orgmode/orgmode' },
    config = function()
      load_treesitter()
      require('org-roam').setup({
        directory = org_root_path .. '/roam/',
        ui = {
          node_buffer = {
            show_keybindings = false,
          },
        },
      })
    end,
  },
  {
    'nvim-orgmode/orgmode',
    lazy = true,
    ft = { 'org' },
    keys = {
      -- { '<leader>e', '<cmd>lua require("hasan.org").toggle_org_float()<CR>', desc = 'Toggle org float' },
      { '<leader>oh', '<cmd>lua require("hasan.org").open_org_home("-tabedit")<CR>', desc = 'Open org home' },
      { '<leader>oH', '<cmd>lua require("hasan.org").open_org_project()<CR>', desc = 'Open current project' },

      { '<leader>oa', loadOrgMode('<space>oa'), desc = 'org agenda' },
      { '<leader>oc', loadOrgMode('<space>oc'), desc = 'org capture' },

      { '<leader>/o', '<cmd>Telescope live_grep cwd=~/my_vault/orgfiles<CR>', desc = 'Grep org text' },
      { '<leader>/w', '<cmd>Telescope find_files cwd=~/my_vault/orgfiles<CR>', desc = 'Search org files' },
      { '<leader>w/', '<cmd>Telescope find_files cwd=~/my_vault/orgfiles<CR>', desc = 'Search org files' },
    },
    opts = {
      org_agenda_files = { '~/my_vault/orgfiles/**/*' },
      org_default_notes_file = org_root_path .. '/refile.org',
      org_hide_leading_stars = true,
      org_hide_emphasis_markers = true,
      org_todo_keywords = { 'TODO', 'NEXT', 'WORKING', 'WAITING', '|', 'DONE', 'CANCELED' },
      org_capture_templates = {
        m = {
          description = 'Mark file',
          template = '** %?\n  %a',
          target = org_root_path .. '/mark_files.org',
        },
        t = {
          description = 'Task',
          headline = 'Quick Tasks',
          template = '** TODO %?\n  %u',
        },
      },
    },
    -- config = function(_, opts)
    --   require('orgmode').setup(opts)
    -- end,
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
  },
}
