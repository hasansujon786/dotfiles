return {
  'folke/which-key.nvim',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    local wk = require('which-key')
    wk.setup({
      window = {
        position = 'bottom', -- bottom, top
        border = { ' ', ' ', ' ', '', '▁', '▁', '▁', '' },
        margin = { 0, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 0, 1, 0 }, -- extra window padding [top, right, bottom, left]
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = 'left', -- align columns left, center or right
      },
      key_labels = {
        ['<space>'] = '󱁐 ',
        ['<CR>'] = '󰌑 ',
        ['<Tab>'] = ' ',
        ['.'] = '•',
      },
      show_help = false,
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = { enabled = true, suggestions = 12 }, -- z=
        presets = {
          operators = true, -- adds help for operators like d, y, ...
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
        },
      },
    })

    local common = {
      findFiles = { '<cmd>lua require("hasan.telescope.custom").my_find_files()<cr>', 'Find file' },
      buffers_cwd = { '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>', 'Switch buffers' },
      buffers_all = { '<cmd>lua require("hasan.telescope.custom").buffers(false)<CR>', 'Switch all buffers' },
      browse_cur_dir = {
        '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>',
        'Browse cur directory',
      },
    }
    local w = {
      name = '+window',
      h = { '<cmd>lua handle_win_cmd("wincmd h")<CR>', 'Window left' },
      j = { '<cmd>lua handle_win_cmd("wincmd j")<CR>', 'Window down' },
      k = { '<cmd>lua handle_win_cmd("wincmd k")<CR>', 'Window up' },
      l = { '<cmd>lua handle_win_cmd("wincmd l")<CR>', 'Window right' },
      H = { '<cmd>lua handle_win_cmd("wincmd H")<CR>', 'Move window left' },
      J = { '<cmd>lua handle_win_cmd("wincmd J")<CR>', 'Move window bottom' },
      K = { '<cmd>lua handle_win_cmd("wincmd K")<CR>', 'Move window top' },
      L = { '<cmd>lua handle_win_cmd("wincmd L")<CR>', 'Move window right' },
      p = { '<cmd>lua handle_win_cmd("wincmd p")<CR>', 'Window previous' },
      w = { '<cmd>lua handle_win_cmd("wincmd w")<CR>', 'Window next' },
      W = { '<cmd>lua handle_win_cmd("wincmd W")<CR>', 'Window previous' },
      v = { '<cmd>lua handle_win_cmd("wincmd v")<CR>', 'Windwo vsplit' },
      s = { '<cmd>lua handle_win_cmd("wincmd s")<CR>', 'Window split' },
      r = { '<cmd>lua handle_win_cmd("wincmd r")<CR>', 'Window rotate+' },
      R = { '<cmd>lua handle_win_cmd("wincmd R")<CR>', 'Window rotate-' },
      o = { '<cmd>lua handle_win_cmd("wincmd o")<CR>', 'Keep only windwo' },
      c = { '<cmd>lua handle_win_cmd("wincmd c")<CR>', 'Close windows' },
      q = { '<cmd>tabclose<CR>', 'Close tab' },
      t = { '<cmd>-tab split<CR>', 'Edit to new tab' },
      O = { '<cmd>tabonly<CR>', 'Keep only tab' },
    }

    local leader = {
      a = { name = '+lsp', d = 'Lsp: show global diagnostics' },
      n = { name = '+visual-multi', A = 'VM: Select All' },

      b = {
        name = '+buffer',
        b = common.buffers_all,
        ['.'] = common.buffers_cwd,
        f = { '<cmd>bfirst<CR>', 'First buffer' },
        l = { '<cmd>blast<CR>', 'Last buffer' },
        n = { '<cmd>bnext<CR>', 'Next buffer' },
        p = { '<cmd>bprevious<CR>', 'Previous buffer' },

        k = { '<cmd>call hasan#utils#buffer#_clear()<CR>', 'Kill this buffer' },
        K = { '<cmd>call hasan#utils#buffer#_clear_all()<CR>', 'Kill all buffers' },
        o = { '<cmd>call hasan#utils#buffer#_clear_other()<CR>', 'Kill other buffers' },

        s = { '<cmd>w<CR>', 'Save buffer' },
        S = { '<cmd>wa<CR>', 'Save all buffer' },

        m = { '<cmd>call hasan#fzf#set_bookmark()<CR>', 'Set bookmark' },
        M = { '<cmd>call hasan#fzf#edit_bookmark()<CR>', 'Delete bookmark' },
      },

      c = {
        name = '+change',

        -- TODO: <12.04.23> change keymap
        m = {
          name = '+hightlight-hints',
          x = { '<cmd>call hiiw#ClearInterestingWord()<cr>', 'Clear hints' },
          y = { '<cmd>call hiiw#HiInterestingWord(1)<cr>', 'Mark hint 1' },
          g = { '<cmd>call hiiw#HiInterestingWord(2)<cr>', 'Mark hint 2' },
          b = { '<cmd>call hiiw#HiInterestingWord(3)<cr>', 'Mark hint 3' },
          w = { '<cmd>call hiiw#HiInterestingWord(4)<cr>', 'Mark hint 4' },
          p = { '<cmd>call hiiw#HiInterestingWord(5)<cr>', 'Mark hint 5' },
          r = { '<cmd>call hiiw#HiInterestingWord(6)<cr>', 'Mark hint 6' },
        },
      },

      d = { name = 'Debug' },

      i = {
        name = '+insert',
        d = { '<cmd>call _#Insertion(strftime("%e %B %Y"))<CR>', 'Current date' },
        t = { '<cmd>call _#Insertion(strftime("%H:%M"))<CR>', 'Current time' },
        f = { '<cmd>call _#Insertion(expand("%:~"))<CR>', 'Current file path' },
        F = { '<cmd>call _#Insertion(expand("%:t"))<CR>', 'Current file name' },
        e = { '<cmd>lua require("hasan.telescope.custom").emojis()<CR>', 'Insert emoji' },
        c = { '<cmd>lua require("hasan.telescope.custom").colors()<CR>', 'Insert colors' },
        l = {
          t = { '<cmd>call _#Insertion(hasan#utils#placeholderImgTag("300x200"))<CR>', 'Placeholder image tag' },
          k = { '<cmd>call _#Insertion("https://placekitten.com/g/50/50")<CR>', 'Sample image link' },
        },
      },

      g = {
        name = '+git',
        ['/'] = { '<cmd>Telescope git_status<CR>', 'Find git files*' },
        b = { '<cmd>Telescope git_branches<CR>', 'Checkout git branch' },
        c = { '<cmd>Telescope git_commits<CR>', 'Look up commits' },
        C = { '<cmd>Telescope git_bcommits<CR>', 'Look up buffer commits' },

        o = { '<cmd>lua require("hasan.utils.init").open_git_remote(true)<CR>', 'Open git repo' },
        O = { '<cmd>lua require("hasan.utils.init").open_git_remote(false)<CR>', 'Open git repo with file' },
        ['.'] = { '<cmd>silent !git add %<CR>', 'Git: Stage file' },
        -- f = { '<cmd>diffget //2<cr>',                      'diffget ours' },
        -- j = { '<cmd>diffget //3<CR>',                      'diffget theirs' },
      },

      f = {
        name = '+file',
        -- File Command
        ['.'] = common.browse_cur_dir,
        b = { '<cmd>lua require("hasan.telescope.custom").file_browser()<cr>', 'Browser project files' },
        f = common.findFiles,
        F = { '<cmd>lua require("hasan.telescope.custom").my_find_files("cur_dir")<cr>', 'Find file from here' },
        p = { '<cmd>lua require("hasan.telescope.custom").project_files()<cr>', 'Find project file' },

        R = { '<cmd>lua require("hasan.widgets.inputs").rename_current_file()<CR>', 'Rename file' },
        x = {
          name = '+remove',
          ['/'] = { '<cmd>lua require("hasan.utils.file").delete_lines_with("comment")<CR>', 'Delete all comments' },
          x = {
            '<cmd>call hasan#autocmd#trimWhitespace()<CR>',
            'Remove white space',
          },
        },

        w = { '<Plug>(fix-current-world)', 'Fix current world' },

        u = {
          name = '+update-permission',
          x = { '<cmd>Chmod +x<CR>', 'Make this file executable' },
          X = { '<cmd>Chmod -x<CR>', 'Remove executable' },
          w = { '<cmd>Chmod +w<CR>', 'Add write permission' },
          W = { '<cmd>Chmod -w<CR>', 'Remove write permission' },
        },
      },

      o = {
        name = '+open',
        q = { '<cmd>call hasan#window#toggle_quickfix(1)<CR>', 'Open Quickfix list' },
        l = { '<cmd>call hasan#window#toggle_quickfix(0)<CR>', 'Open Local list' },
      },

      p = {
        name = '+project',
        c = {
          '<cmd>lua require("telescope._extensions").manager.project_commands.commands()<CR>',
          'Run project commands',
        },

        p = { '<cmd>lua require("hasan.telescope.custom").projects()<CR>', 'Switch project' },
        r = { '<cmd>lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>', 'Find recent files' },
        t = { '<cmd>lua require("hasan.telescope.custom").search_project_todos()<CR>', 'Search project todos' },
        b = { '<cmd>lua require("hasan.telescope.custom").project_browser()<CR>', 'Browse other projects' },

        d = { '<cmd>Alpha<CR>', 'Open dashboard' },
        l = { '<cmd>SessionLoad<CR>', 'Load session' },
        s = { '<cmd>SessionSave<CR>', 'Save session' },
        m = { '<cmd>lua require("telescope._extensions").manager.persisted.persisted()<CR>', 'Show session menu' },
        z = { '<cmd>lua require("config.telescope.persisted").save_and_exit()<CR>', 'Save session and quit' },
      },

      t = {
        name = '+toggle',
        b = { '<cmd>lua require("hasan.utils.color").toggle_bg_tranparent(false)<CR>', 'Toggle transparency' },
        B = 'Toggle Onedark',

        l = { '<cmd>lua require("hasan.utils.logger").toggle("cursorcolumn")<CR>', 'Toggle cursorcolumn' },
        L = { '<cmd>lua require("hasan.utils.logger").toggle("cursorline")<CR>', 'Toggle cursorline' },
        t = { '<cmd>lua require("hasan.utils.logger").toggle("concealcursor", { "nc", "" })<CR>', 'Toggle concealcursor' },
        o = { '<cmd>lua require("hasan.utils.logger").toggle("conceallevel", { 0, 2 })<CR>', 'Toggle conceallevel' },
        s = { '<cmd>lua require("hasan.utils.logger").toggle("spell")<CR>', 'Toggle spell' },
        w = { '<cmd>lua require("hasan.utils.logger").toggle("wrap")<CR>', 'Toggle wrap' },
        W = { '<cmd>call autohl#_AutoHighlightToggle()<CR>', 'Highlight same words' },
      },

      v = {
        name = '+vim',
        ['/'] = { '<cmd>Telescope help_tags<CR>', 'Search Vim help' },
        ['.'] = { '<cmd>echo "Not a Vim file"<CR>', 'Source this file' },
        d = { '<cmd>lua require("hasan.telescope.custom").search_nvim_data()<CR>', 'Search nvim data' },
        l = { '<cmd>call logevents#LogEvents_Toggle()<CR>', 'Toggle LogEvents' },
        R = { '<cmd>ReloadConfig<CR>', 'Reload neovim' },
        H = { '<cmd>silent write | edit | TSBufEnable highlight<CR>', 'Reload hightlight' },
        p = { '<cmd>Lazy home<CR>', 'Plugin status' },
        s = { '<cmd>lua require("hasan.utils.file").open_settings()<CR>', 'Open settings' },
        P = { '<cmd>lua require("hasan.telescope.custom").search_plugins()<CR>', 'Search plugin files' },
      },

      w = w,

      ['/'] = {
        name = '+search',
        ['.'] = { '<cmd>Telescope resume<cr>', 'Telescope resume' },
        b = common.buffers_cwd,
        f = common.findFiles,
        k = { '<cmd>Telescope keymaps<CR>', 'Look up keymaps' },
        r = { '<cmd>Telescope oldfiles<CR>', 'Recent files' },
        t = { '<cmd>Telescope filetypes theme=get_dropdown<CR>', 'Change filetypes' },

        ['/'] = { '<cmd>Telescope live_grep<CR>', 'Live grep' },
        g = { '<cmd>lua require("hasan.telescope.custom").live_grep_in_folder()<cr>', 'Live grep in folder' },
      },

      r = { '<cmd>lua require("hasan.utils.win").cycle_numbering()<CR>', 'Cycle number' },
      x = { '<cmd>call hasan#utils#buffer#_open_scratch_buffer()<CR>', 'Scratch buffer' },

      ['.'] = common.browse_cur_dir,
      ['m'] = common.buffers_cwd,
    }

    local leader_visual = {
      o = { name = '+open' },
      c = { name = '+change' },
      n = { name = '+visual-multi' },
    }

    wk.register(leader, { prefix = '<leader>' })
    wk.register(leader_visual, { prefix = '<leader>', mode = 'v' })
  end,
}
