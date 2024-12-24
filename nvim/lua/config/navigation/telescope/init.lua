return {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  enablea = true,
  cmd = 'Telescope',
  -- event = 'VeryLazy',
  -- stylua: ignore
  keys = {
    -- FIND FILES
    { '<leader><space>', '<cmd>lua require("hasan.telescope.custom").project_files()<cr>', desc = 'Find project file' },
    { '<leader>.', '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>', desc = 'Browse cur directory' },
    { '<leader>f.', '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>', desc = 'Browse cur directory' },
    { '<leader>ff', '<cmd>lua require("hasan.telescope.custom").my_find_files()<cr>', desc = 'Find file' },
    { '<leader>fb', '<cmd>lua require("hasan.telescope.custom").file_browser()<cr>', desc = 'Browser project files' },
    { '<leader>fg', '<cmd>Telescope git_files<cr>', desc = 'Find git files' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },

    -- FIND BUFFERS
    { "g'", '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>', desc = 'Switch buffers' },
    { '<leader>bb', '<cmd>lua require("hasan.telescope.custom").buffers(false)<CR>', desc = 'Switch all buffers' },

    -- LSP
    { 'go', '<cmd>lua require("hasan.telescope.lsp").prettyTreesitter({ show_line = true })<CR>', desc = 'Lsp: Document symbols' },
    { '<leader>ar', '<cmd>lua require("hasan.telescope.custom").references()<cr>', desc = 'Lsp: Preview references' },

    -- GIT
    { '<leader>g/', '<cmd>Telescope git_status<CR>', desc = 'Find git files*' },
    { '<leader>gb', '<cmd>Telescope git_branches<CR>', desc = 'Checkout git branch' },
    { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'Look up commits' },
    { '<leader>gC', '<cmd>Telescope git_bcommits<CR>', desc = 'Look up buffer commits' },

    -- SEARCH
    { '<leader>/.', '<cmd>Telescope resume<cr>', desc = 'Telescope resume' },
    { '<leader>//', '<cmd>Telescope live_grep<CR>', desc = 'Live grep' },
    { '<leader>/f', '<cmd>lua require("hasan.telescope.custom").my_find_files()<cr>', desc = 'Find file' },
    { '<leader>/g', '<cmd>lua require("hasan.telescope.custom").live_grep_in_folder()<cr>', desc = 'Live grep in folder' },
    { '<leader>/k', '<cmd>Telescope keymaps<CR>', desc = 'Look up keymaps' },
    { '<leader>/t', '<cmd>Telescope filetypes<CR>', desc = 'Change filetypes' },
    { '<leader>/q', '<cmd>Telescope quickfix<cr>', desc = 'Quickfix List' },

    { '//', '<cmd>lua require("hasan.telescope.custom").auto_open_qflistt_or_loclist()<cr>', ft = 'qf', desc = 'which_key_ignore' },
    { '//', '<cmd>lua require("hasan.telescope.custom").curbuf()<cr>', desc = 'which_key_ignore' },
    { '/', '<Esc><cmd>lua require("hasan.telescope.custom").curbuf(true)<cr>', desc = 'which_key_ignore', mode = 'v' },

    { '<A-/>', '<cmd>lua require("hasan.telescope.custom").grep_string()<CR>', desc = 'Grep string' },
    { '<A-/>', '<Esc><cmd>lua require("hasan.telescope.custom").grep_string(true)<CR>', desc = 'Grep string', mode = 'v' },
    { '<C-p>', '<cmd>lua require("telescope.builtin").oldfiles()<CR>', desc = 'Recent files' },
    { '<A-c>', '<cmd>lua require("hasan.telescope.custom").commands()<CR>', desc = 'Nvim commands' },

    -- PROJECT
    { '<leader>pc', '<cmd>lua require("telescope._extensions").manager.project_commands.commands()<CR>', desc = 'Run project commands' },
    { '<leader>pr', '<cmd>lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>', desc = 'Find recent files' },
    { '<leader>pt', '<cmd>lua require("hasan.telescope.custom").search_project_todos()<CR>', desc = 'Search project todos' },

    { '<leader>pb', '<cmd>lua require("hasan.telescope.custom").project_browser()<CR>', desc = 'Browse other projects' },
    { '<leader>pm', '<cmd>lua require("hasan.telescope.custom").projects()<CR>', desc = 'Switch project' },
    { '<leader>pp', '<cmd>lua require("telescope._extensions").manager.persisted.persisted()<CR>', desc = 'Show session list' },

    -- VIM
    { '<leader>v/', '<cmd>Telescope help_tags<CR>', desc = 'Search Vim help' },
    { '<leader>vd', '<cmd>lua require("hasan.telescope.custom").search_nvim_data()<CR>', desc = 'Search nvim data' },
    { '<leader>vj', '<cmd>Telescope jumplist<cr>', desc = 'Search jumplist' },
    { '<leader>vm', '<cmd>Telescope marks<cr>', desc = 'Jump to Marks' },
  },
  config = function()
    local Icons = require('hasan.utils.ui.icons')
    local actions = require('telescope.actions')
    local fb_actions = require('telescope._extensions.file_browser.actions')
    local state = require('core.state')
    local local_action = require('hasan.telescope.local_action')
    local local_theme = require('hasan.telescope.theme')

    local custom_mappings = {
      ['<M-u>'] = actions.preview_scrolling_up,
      ['<M-d>'] = actions.preview_scrolling_down,
      ['<up>'] = actions.cycle_history_prev,
      ['<down>'] = actions.cycle_history_next,

      ['<M-p>'] = actions.move_selection_previous,
      ['<M-n>'] = actions.move_selection_next,
      ['<tab>'] = actions.move_selection_next,
      ['<s-tab>'] = actions.move_selection_previous,

      ['<M-i>'] = actions.toggle_selection + actions.move_selection_worse,
      ['<M-y>'] = actions.toggle_selection + actions.move_selection_better,

      ['<C-o>'] = local_action.system_open,
      ['<S-CR>'] = local_action.fedit,
      ['<M-o>'] = local_action.quicklook(),
      ['<C-s>'] = actions.select_horizontal,
      ['<M-t>'] = local_action.focus_file_tree,
      ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,

      ['<M-a>'] = actions.select_all,
      ['<C-e>'] = actions.to_fuzzy_refine,
      ['<esc>'] = actions.close,
      ['jk'] = function()
        vim.cmd('stopinsert')
      end,
      ['<M-q>'] = function(...)
        require('telescope.actions.layout').toggle_preview(...)
      end,

      ['<C-x>'] = false,
      ['<C-u>'] = false,
      ['<C-d>'] = false,
    }

    local bordercharsOpt = { borderchars = state.border_groups.edged_top }
    local get_dropdown = require('telescope.themes').get_dropdown(bordercharsOpt)
    local get_cursor = require('telescope.themes').get_cursor(bordercharsOpt)
    local get_ivy = require('telescope.themes').get_ivy({ borderchars = state.border_groups.edged_ivy })

    require('telescope').setup({
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '-g',
          '!/vendor',
        },
        results_title = false,
        preview_title = false,
        scroll_strategy = 'cycle',
        selection_strategy = 'reset',
        multi_icon = '▸',
        prompt_prefix = '   ',
        selection_caret = '❯ ',
        path_display = { 'filename_first' },
        -- sorting_strategy = "ascending",
        layout_config = {
          height = 0.7,
          width = 0.8,
        },
        borderchars = state.border_groups[state.ui.telescope_border_style],
        winblend = 0,
        mappings = { n = custom_mappings, i = custom_mappings },
        file_ignore_patterns = {
          -- dotfiles
          '%.system/.*',
          '%.bin/.*',
          'gui/sublime_text/.*',
          'nvim/tmp/archive',
          '4_archive/.*',
          -- git
          '%.gitignore',
          '%.git/.*',
          -- projects
          'android/.*',
          'ios/.*',
          'vendor/.*',
          'pubspec.lock',
        },
      },
      pickers = {
        -- lsp_references = dropdown_opts,
        find_files = get_ivy,
        lsp_document_symbols = get_dropdown,
        grep_string = get_dropdown,
        live_grep = get_dropdown,
        filetypes = get_dropdown,
        treesitter = get_dropdown,
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true,
          override_file_sorter = true,
        },
        ['ui-select'] = {
          get_dropdown,
          specific_opts = {
            -- ['codeaction'] = {},
            picker_opts = {
              codeaction = get_cursor,
              cursor = get_cursor,
            },
          },
        },
        persisted = get_dropdown,
        project_commands = require('config.navigation.telescope.project_commands'),
        file_browser = {
          theme = 'ivy',
          cwd_to_path = false,
          grouped = true,
          files = true, -- false: start with all dirs
          hidden = false,
          hide_parent_dir = true,
          prompt_path = true,
          quiet = false,
          dir_icon = Icons.documents.FolderOpen,
          dir_icon_hl = 'Default',
          display_stat = { date = true, size = true },
          git_status = true,
          mappings = {
            ['i'] = {
              -- ['<A-c>'] = fb_actions.create,
              -- ['<A-r>'] = fb_actions.rename,
              -- ['<A-m>'] = fb_actions.move,
              -- ['<A-y>'] = fb_actions.copy,
              -- ['<A-d>'] = fb_actions.remove,
              -- ['<S-CR>'] = fb_actions.create_from_prompt,

              ['<tab>'] = actions.select_default,
              ['<C-o>'] = local_action.fb_system_open,
              ['<M-o>'] = local_action.quicklook(true),
              ['<C-i>'] = fb_actions.toggle_hidden,
              ['<C-f>'] = fb_actions.toggle_browser, -- Search for all folders

              ['<bs>'] = fb_actions.backspace,
              ['<A-h>'] = fb_actions.goto_home_dir,
              ['<C-u>'] = local_action.fb_clear_prompt_or_goto_cwd,
              ['<C-w>'] = local_action.fb_clear_prompt_or_goto_parent_dir,

              ['<C-h>'] = false,
            },
            ['n'] = {
              ['<tab>'] = actions.select_default,
              ['o'] = local_action.fb_system_open,
              ['I'] = fb_actions.toggle_hidden,

              ['-'] = fb_actions.goto_parent_dir,
              ['<bs>'] = fb_actions.goto_parent_dir,
              ['H'] = fb_actions.goto_home_dir,
              ['W'] = fb_actions.goto_cwd,

              ['f'] = false,
              ['s'] = false,
              ['h'] = false,
            },
          },
        },
      },
    })
    require('telescope').load_extension('fzf')
    local_theme.setup()

    -- keymaps
    command('EmojiPicker', function()
      require('hasan.telescope.custom').emojis()
    end)
  end,
  init = function()
    vim.ui.select = function(...)
      require('lazy').load({ plugins = { 'telescope.nvim' } })
      require('telescope').load_extension('ui-select')
      return vim.ui.select(...)
    end
  end,
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'hasansujon786/telescope-ui-select.nvim' },
  },
}
