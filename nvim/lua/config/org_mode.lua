local function load_treesitter()
  if package.loaded['nvim-treesitter'] == nil then
    require('lazy').load({ plugins = { 'nvim-treesitter' } })
  end
end
local function loadOrgMode(key)
  return function()
    load_treesitter()
    require('lazy').load({ plugins = { 'orgmode' } })
    vim.defer_fn(function()
      feedkeys(key)
    end, 0)
  end
end

return {
  {
    'chipsenkbeil/org-roam.nvim',
    -- enabled = true,
    module = 'org-roam',
    keys = {
      { '<leader>nc', desc = 'Opens org-roam capture window' },
      { '<leader>nf', desc = 'Finds org-roam node and moves to it, creating new one if missing' },
    },
    cmd = { 'RoamUpdate', 'RoamSave' },
    ft = { 'org' },
    lazy = true,
    dependencies = { 'nvim-orgmode/orgmode' },
    config = function()
      load_treesitter()
      require('org-roam').setup({
        directory = org_root_path,
        ui = {
          node_buffer = {
            show_keybindings = false,
          },
        },
      })
    end,
  },
  {
    -- 'nvim-orgmode/orgmode',
    'hasansujon786/orgmode',
    branch = 'fix-autocomplete/tags-search-prompt',
    lazy = true,
    ft = { 'org' },
    keys = {
      -- { '<leader>e', '<cmd>lua require("hasan.org").toggle_org_float()<CR>', desc = 'Toggle org float' },
      { '<leader>oh', '<cmd>lua require("hasan.org").open_org_home("-tabedit")<CR>', desc = 'Open org home' },
      { '<leader>oH', '<cmd>lua require("hasan.org").open_org_project()<CR>', desc = 'Open current project' },

      { '<leader>oa', loadOrgMode('<space>oa'), desc = 'org agenda' },
      { '<leader>oc', loadOrgMode('<space>oc'), desc = 'org capture' },

      { '<leader>/o', '<cmd>Telescope live_grep cwd=~/my_vault/orgfiles<CR>', desc = 'Grep org text' },
      { '<leader>w/', '<cmd>Telescope find_files cwd=~/my_vault/orgfiles<CR>', desc = 'Search org files' },
      { '<leader>w.', '<cmd>Telescope file_browser cwd=~/my_vault/orgfiles<CR>', desc = 'Browse org files' },
    },
    opts = {
      org_agenda_files = { '~/my_vault/orgfiles/**/*' },
      org_default_notes_file = org_root_path .. '/refile.org',
      org_hide_leading_stars = true,
      org_startup_indented = true,
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
      ui = {
        menu = {
          handler = function(data)
            local options = {}
            local data_by_key = {}

            for _, item in ipairs(data.items) do
              -- Only MenuOption has `key`
              -- Also we don't need `Quit` option because we can close the menu with ESC
              if item.key and item.key ~= 'q' then
                table.insert(options, { label = item.label, key = item.key })
                data_by_key[item.key] = item
              end
            end

            local handler = function(choice)
              if not choice then
                return
              end
              local option = data_by_key[choice.key]
              if option.action then
                option.action()
              end
            end

            require('hasan.widgets').get_select(options, handler, {
              prompt = ' ' .. data.title .. ' ',
              kind = 'get_char',
              min_width = 40,
              win_config = { win_options = { number = false } },
              format_item = function(item)
                return string.format('   %s - %s', item.key, item.label)
              end,
            })
          end,
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
            headlines = { '◎', '◯', '', '', '✸', '', '♥', '✿' },
            checkboxes = {
              half = { '-', '@org.checkbox.halfchecked' },
              done = { '✓', '@org.keyword.done' },
              todo = { ' ', '@org.keyword.todo' },
            },
          },
        },
      },
    },
  },
}
