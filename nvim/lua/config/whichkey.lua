local wk = require("which-key")

wk.setup {
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 0, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 0, 2, 0 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  key_labels = {
    ['<space>'] = 'SPC',
    ['<CR>'] = 'RET',
    ['<Tab>'] = 'TAB',
  },
  show_help = false,
}


local leader = {
  a = {
    name = "+lsp", -- optional group name
    c = { '<cmd>CocList commands<CR>',                   'commands' },
    e = { '<cmd>CocList extensions<CR>',                 'extensions' },
    o = { '<cmd>CocList outline<CR>',                    'outline' },
    S = { '<cmd>CocList snippets<CR>',                   'snippets' },
    T = { '<cmd>CocList tasks<CR>',                      'list-tasks' },
    s = { '<cmd>CocList -I symbols<CR>',                 'symbol-references' },

    h = { '<Plug>(coc-float-hide)',               'float-hide' },
    j = { '<Plug>(coc-float-jump)',               'float-jump' },
    l = { '<Plug>(coc-codelens-action)',          'code-lens' },

    -- a = 'coc-action',
    -- f = 'format',

    ['?'] = { '<cmd>CocList diagnostics<CR>',            'diagnostics' },
    ['.'] = { '<cmd>CocListResume<CR>',                  'resume-list' },
    [';'] = { '<cmd>CocList<CR>',                        'coc-lists' },
    [','] = { '<cmd>CocConfig<CR>',                      'config' },
    ['$'] = { '<cmd>CocRestart<CR>',                     'coc-restart' },
    U = { '<cmd>CocUpdate<CR>',                          'update-CoC' },
  },

  b = {
    name = '+buffer',
    ['/'] = { ':Telescope buffers<CR>',                        'Search buffers' },
    f = { '<cmd>bfirst<CR>',                                   'First buffer' },
    l = { '<cmd>blast<CR>',                                    'Last buffer' },
    n = { '<cmd>bnext<CR>',                                    'Next buffer' },
    p = { '<cmd>bprevious<CR>',                                'Previous buffer' },

    k = { '<cmd>Bclose<CR>',                                   'Kill this buffer' },
    K = { '<cmd>call hasan#utils#clear_all_buffers()<CR>',     'Kill all buffers' },
    o = { '<cmd>call hasan#utils#clear_other_buffers()<CR>',   'Kill other buffers' },

    s = { '<cmd>w<CR>',                                        'Save buffer' },
    S = { '<cmd>wa<CR>',                                       'Save all buffer' },

    m = { '<cmd>call hasan#fzf#set_bookmark()<CR>',            'Set bookmark' },
    M = { '<cmd>call hasan#fzf#edit_bookmark()<CR>',           'Delete bookmark' },
  },

  i = {
    name = '+insert',
    d = { ':call _#Insertion(strftime("%e %B %Y"))<CR>',            'Current date' },
    t = { ':call _#Insertion(strftime("%H:%M"))<CR>',               'Current time' },
    f = { ':call _#Insertion(expand("%:~"))<CR>',                   'Current file path' },
    F = { ':call _#Insertion(expand("%:t"))<CR>',                   'Current file name' },
    p = 'Paste form CB',
  },

  g = {
    name = '+git',
    ['/'] = { ':Telescope git_status<CR>',         'Find git files*' },
    ['.'] = { ':Git add %<CR>',                    'stage-current-file' },
    b = { ':Git blame<CR>',                        'blame' },
    L = { ':Git log<CR>',                          'log' },
    f = { ':diffget //2<CR>',                      'diffget ours' },
    j = { ':diffget //3<CR>',                      'diffget theirs' },
    d = { ':Gvdiffsplit!<CR>',                     'diff' },
    B = { ':GBrowse<CR>',                          'browse-repo' },
    r = { ':GRemove<CR>',                          'remove' },
    v = { ':GV<CR>',                               'view-commits' },
    V = { ':GV!<CR>',                              'view-buffer-commits' },

    l = { ':FloatermNew lazygit<CR>',              'Open lazygit' },
    t = { ':FloatermNew tig<CR>',                  'Open tig' },

    g = { ':Neogit kind=split<CR>',                'Open Neogit' },
    G = { ':Neogit<CR>',                           'Open NeogitTab' },

    U = { ':GitGutter<CR>',                        'update-gitgutter' },
    F = { ':GitGutterFold<CR>',                    'fold-around-hunk' },
    H = { ':GitGutterLineHighlightsToggle<CR>',    'highlight-hunks' },
    T = { ':GitGutterSignsToggle<CR>',             'toggle-signs' },
    s = { '<Plug>(GitGutterStageHunk)',            'stage-hunk' },
    u = { '<Plug>(GitGutterUndoHunk)',             'undo-hunk' },
    p = { '<Plug>(GitGutterPreviewHunk)',          'preview-hunk' },
  },

  f = {
    name = '+file',
    -- File Command
    f = { ':Telescope find_files<CR>',         'Find file' },
    b = { ':Telescope file_browser<CR>',       'Open file browser' },
    i = { ':call hasan#utils#file_info()<CR>', 'Show file info' },
    s = { ':write<CR>',                        'Save current file' },
    S = { ':wa<CR>',                           'Save all file' },
    y = { ':CopyFileNameToClipBoard!<CR>',     'Yank file name' },
    Y = { ':CopyFileNameToClipBoard<CR>',      'Yank path name' },
    R = 'Rename file',
    C = 'Copy this file',
    M = 'Move/rename file',

    -- Word command
    w = { '<Plug>FixCurrentWord',              'Fix current world' },
    ['.'] = 'Rename current word',
    -- F = { ':FilesCurDir<CR>',                    'Find file from here' },
    -- d = { ':FilesCurDir<CR>',                    'Find directory' },
    u = {
      name = '+update-permission',
      x = { ':Chmod +x<CR>',                   'Make this file executable' },
      X = { ':Chmod -x<CR>',                   'Remove executable' },
      w = { ':Chmod +w<CR>',                   'Add write permission' },
      W = { ':Chmod -w<CR>',                   'Remove write permission' },
    },
  },

  o = {
    name = '+open',
    ['-'] = { ':FernCurDir<CR>',                                'Fern' },
    a = 'Org agenda',
    c = 'Org capture',
    -- a = { '<Plug>(dotoo-agenda)',                               '+org-agenda' },
    -- c = { '<Plug>(dotoo-capture-custom)',                       '+org-capture' },
    t = { ':FloatermNew bash<CR>',                              'Open terminal popup' },
    T = { ':FloatermNew --wintype=normal --height=10 bash<CR>', 'Open terminal split' },
    q = { ':QfixToggle<CR>',                                    'Quickfix' },
    y = { ':CocList --normal yank<CR>',                         'Yank list' },
    p = { ':FernDrawerToggle!<CR>',                             'Project sidebar' },
    P = { ':FernCurDirDrawer<CR>',                              'Dir in preject sidebar' },
  },

  p = {
    name = '+project',
    p = { ':SwitchProjects<CR>',         'Switch project' },
    r = { ':lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>',  'Find recent files' },
    b = { ':Telescope file_browser prompt_title=Project\\ Browser cwd=D:\\repoes<CR>',  'Browse other projects' },

    l = { ':SessionLoad<CR>',                       'Load session' },
    s = { ':SessionSave<CR>',                       'Save session' },
    q = { ':SessionSaveAndQuit<CR>',                'Save session and quit' },
    d = { ':Dashboard<CR>',                         'Open dashboard' },
  },

  t = {
    name = '+toggle',
    c = { ':setlocal cursorcolumn!<CR>',            'cursorcolumn' },
    w = { ':call hasan#utils#toggleWrap()<CR>',     'toggle-wrap' },

    t = {
      name  = '+task-and-timer',
      w = { ':Work<CR>',                            'Start work timer' },
      s = { ':TimerShow<CR>',                       'Show timer status' },
      p = { ':TimerToggle<CR>',                     'Pause or Paly' },
      b = { ':Break<CR>',                           'Take a break' },
      o = { ':OpenTasks<CR>',                       'Open tasks' },
      -- TODO: use input metheo to get user valeu
      -- u = { ':UpdateCurrentTimer',                   'Update current timer' },
      -- U = { ':UpdateCurrentStatus',                  'Update current status' },
    }
  },

  v = {
    name = '+vim',
    -- TODO
    -- e = 'print-to-float',
    -- nnoremap <leader>ve :call _#print_to_float(g:)<left>
    l = { ':call logevents#LogEvents_Toggle()<CR>',  'Toggle LogEvents' },
    p = {
      name = '+plugin',
      c = { 'Compile plugin setup' },
      C = { ':PackerClean<CR>',             'Clean plugins' },
      i = { ':PackerInstall<CR>',           'Install plugins' },
      s = { ':PackerStatus<CR>',            'Plugin status' },
      u = { ':PackerUpdate<CR>',            'Update plugins' },
      p = { ':lua require("hasan.telescope.custom").search_plugins()<CR>',  'Search plugin files'},
    },
  },

  w = {
    name= '+window',
    h = { '<C-w>h',                      'Window left' },
    j = { '<C-w>j',                      'Window down' },
    k = { '<C-w>k',                      'Window up' },
    l = { '<C-w>l',                      'Window right' },
    H = { '<C-w>H',                      'Move window left' },
    J = { '<C-w>J',                      'Move window bottom' },
    K = { '<C-w>K',                      'Move window top' },
    L = { '<C-w>L',                      'Move window right' },
    p = { '<C-w>p',                      'Window previous' },
    w = { '<C-w>w',                      'Window next' },
    W = { '<C-w>W',                      'Window previous' },
    v = { '<C-w>v',                      'Windwo vsplit' },
    s = { '<C-w>s',                      'Window split' },
    r = { '<C-w>r',                      'Window rotate+' },
    R = { '<C-w>R',                      'Window rotate-' },
    o = { '<C-w>o',                      'Keep only windwo' },
    c = { '<C-w>c',                      'Close windows' },
    q = { '<C-w>c',                      'Close windows' },
    t = { '<cmd>-tab split<CR>',         'Edit to new tab' },
    O = { '<cmd>tabonly<CR>',            'Keep only tab' },
    z = { '<cmd>AutoZoomWin<CR>',        'Toggle window zoom' },

    -- wiki
    -- i = 'diary-index',
    -- n = 'diary-today',
    -- N = 'diary-today-tab',
    -- g = 'diary-generate-links',
    T = { ':VimwikiTabIndex<CR>',        'wiki-index-tab'},
    ['.'] = { ':VimwikiIndex<CR>',       'Open wiki index' },
    ['?'] = { ':VimwikiUISelect<CR>',    'Wiki ui select' },
    ['/'] = { ':lua require("hasan.telescope.custom").search_wiki_files()<CR>',   'Search wiki files'},

  },

  ['/'] = {
    name = '+search',
    ['/'] = { ':Telescope live_grep<CR>',   'Find file' },
    b = { ':Telescope buffers<CR>',         'Find buffers' },
    B = { ':Telescope git_bcommits<CR>',    'Look up buffer commits' },
    c = { ':Telescope git_commits<CR>',     'Look up commits' },
    d = { ':Telescope file_browser<CR>',    'Change filetypes' },
    f = { ':Telescope find_files<CR>',      'Find file' },
    g = { ':Telescope git_status<CR>',      'Find git files*' },
    k = { ':Telescope keymaps<CR>',         'Look up keymaps' } ,
    M = { ':Telescope marks<CR>',           'Jump to marks' } ,
    r = { ':Telescope oldfiles<CR>',        'Recent files' },
    t = { ':Telescope filetypes<CR>',       'Change filetypes' },
    s = { ':lua require("hasan.telescope.custom").grep_string()<CR>',         'Grep string' },
    w = { ':lua require("hasan.telescope.custom").search_wiki_files()<CR>',   'Search wiki files'},
    -- m = { ':Bookmarks<CR>',                 'Jump to bookmark' } ,
  },

  y = 'Yank to CB',
  d = 'Delete to CB',
  q = { '<cmd>Quit<cr><CR>',                              'Close window' },
  r = { '<cmd>CycleNumber<CR>',                           'Cycle number' },
  R = { '<cmd>call nebulous#toggle()<CR>',                'Toggle Nebulous' },
  s = { '<cmd>write<CR>',                                 'Save file' },
  n = { '<cmd>FernDrawerToggle<CR>',                      'Toggle sidebar' },
  x = { '<cmd>bdelete<CR>',                               'Delete buffer' },
  z = { 'za',                                             'Fold/Unfold' },
  m = { ':lua require("harpoon.mark").add_file()<CR>',    'Mark to Harpoon' },

  ['.'] = { '<cmd>Telescope commands<CR>',                'Commands panel' },
  [';'] = { '<cmd>Telescope command_history<CR>',         'Search recent cmd' },
  ['<space>'] = { '<cmd>ProjectFiles<cr>',                'Find File' },
  ['<tab>'] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', 'Open Harpoon' },

  h = { '<cmd>JumpToWin h<CR>',                           'which_key_ignore' },
  j = { '<cmd>JumpToWin j<CR>',                           'which_key_ignore' },
  k = { '<cmd>JumpToWin k<CR>',                           'which_key_ignore' },
  l = { '<cmd>JumpToWin l<CR>',                           'which_key_ignore' },
  ['1'] = { ':lua require("harpoon.ui").nav_file(1)<CR>', 'which_key_ignore'},
  ['2'] = { ':lua require("harpoon.ui").nav_file(2)<CR>', 'which_key_ignore'},
  ['3'] = { ':lua require("harpoon.ui").nav_file(3)<CR>', 'which_key_ignore'},
  ['4'] = { ':lua require("harpoon.ui").nav_file(4)<CR>', 'which_key_ignore'},
  ['5'] = { ':lua require("harpoon.ui").nav_file(5)<CR>', 'which_key_ignore'},
}

wk.register(leader, { prefix = '<leader>' })

-- " nmap <leader>aa <Plug>(coc-codeaction)
-- " vmap <leader>aa <Plug>(coc-codeaction-selected)
-- " nmap <leader>af <Plug>(coc-format)
-- " vmap <leader>af <Plug>(coc-format-selected)

-- for i = 0, 10 do
--   leader[tostring(i)] = "which_key_ignore"
-- end
