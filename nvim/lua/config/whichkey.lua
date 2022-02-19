local wk = require('which-key')
wk.setup {
  window = {
    border = 'none', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
    margin = { 0, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 0, 2, 0 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'left', -- align columns left, center or right
  },
  key_labels = {
    ['<space>'] = 'SPC',
    ['<CR>'] = 'RET',
    ['<Tab>'] = 'TAB',
  },
  show_help = false,
}

local common = {
  search_wiki_files = { ':lua require("hasan.telescope.custom").search_wiki_files()<CR>', 'Search org files'},
  grep_org_text = { ':lua require("hasan.telescope.custom").grep_org_text()<CR>',         'Grep org text'},
  buffers_cwd = { '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>',         'Switch Project buffers' },
  buffers_all = { '<cmd>lua require("hasan.telescope.custom").buffers(false)<CR>',        'Switch all buffers' },
}

local leader = {
  a = {
    name = '+lsp',
    d = 'Show diagnostics',
    h = 'Show signature help',
    p = { '<cmd>lua require("telescope.builtin").lsp_definitions({ jump_type = "never" })<CR>',   'Preview defination' },
    r = { '<cmd>lua require("telescope.builtin").lsp_references()<CR>',                           'Preview references' },
    ['+'] = 'Add workspace folder',
    ['-'] = 'Remove workspace folder',
    ['?'] = 'List workspace folder',
  },

  b = {
    name = '+buffer',
    b = common.buffers_cwd,
    B = common.buffers_all,
    f = { '<cmd>bfirst<CR>',                                   'First buffer' },
    l = { '<cmd>blast<CR>',                                    'Last buffer' },
    n = { '<cmd>bnext<CR>',                                    'Next buffer' },
    p = { '<cmd>bprevious<CR>',                                'Previous buffer' },

    k = { '<cmd>call hasan#utils#buffer#_clear()<CR>',         'Kill this buffer' },
    K = { '<cmd>call hasan#utils#buffer#_clear_all()<CR>',     'Kill all buffers' },
    o = { '<cmd>call hasan#utils#buffer#_clear_other()<CR>',   'Kill other buffers' },

    s = { '<cmd>w<CR>',                                        'Save buffer' },
    S = { '<cmd>wa<CR>',                                       'Save all buffer' },

    m = { '<cmd>call hasan#fzf#set_bookmark()<CR>',            'Set bookmark' },
    M = { '<cmd>call hasan#fzf#edit_bookmark()<CR>',           'Delete bookmark' },
  },

  c = {
    c = { '<Plug>ColorConvertCycle',                 'Cycle color' },
    x = { '<Plug>ColorConvertHEX',                   'Convert color to HEX' },
    h = { '<Plug>ColorConvertHSL',                   'Convert color to HSL' },
    r = { '<Plug>ColorConvertRGB',                   'Convert color to RGB' },
  },

  i = {
    name = '+insert',
    d = { ':call _#Insertion(strftime("%e %B %Y"))<CR>',             'Current date' },
    t = { ':call _#Insertion(strftime("%H:%M"))<CR>',                'Current time' },
    f = { ':call _#Insertion(expand("%:~"))<CR>',                    'Current file path' },
    F = { ':call _#Insertion(expand("%:t"))<CR>',                    'Current file name' },

    l = {
      t = { ':call _#Insertion(hasan#utils#placeholderImgTag("300x200"))<CR>', 'Placeholder image tag' },
      k = { ':call _#Insertion("https://placekitten.com/g/50/50")<CR>',        'Sample image link' },
    },

    p = 'Paste form Clip',
  },

  g = {
    name = '+git',
    ['/'] = { ':Telescope git_status<CR>',         'Find git files*' },
    c = { ':Telescope git_commits<CR>',            'Look up commits' },
    C = { ':Telescope git_bcommits<CR>',           'Look up buffer commits' },
    b = { ':Telescope git_branches<CR>',           'Checkout git branch' },
    B = { ':lua require("hasan.utils.init").open_git_remote(false)<CR>',   'Browse git repo' },

    g = { ':Neogit<CR>',                                                    'Open Neogit' },
    l = { ':FloatermNew --height=1.0 --width=1.0 lazygit<CR>',              'Open lazygit' },
    t = { ':FloatermNew --height=1.0 --width=1.0 tig<CR>',                  'Open tig' },

    p = 'Preview hunk',
    r = 'Reset hunk',
    s = 'Stage hunk',
    u = 'Undo last hunk',
    R = 'Reset buffer',
    H = { ':GitGutterLineHighlightsToggle<CR>',    'Highlight hunks' },
    T = { ':GitGutterToggle<CR>',                  'Toggle Signes' },
    ['.'] = { ':silent !git add %<CR>',            'Stage current file' },
    -- f = { ':diffget //2<cr>',                      'diffget ours' },
    -- j = { ':diffget //3<CR>',                      'diffget theirs' },
  },

  f = {
    name = '+file',
    -- File Command
    b = { '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>', 'Browse file directory' },
    d = { '<cmd>lua require("hasan.telescope.custom").file_browser()<cr>',          'Browser project files' },
    f = { '<cmd>lua require("hasan.telescope.custom").file_files()<cr>',            'Find file' },
    F = { '<cmd>lua require("hasan.telescope.custom").file_files("cur_dir")<cr>',   'Find file from here' },

    i = { ':call hasan#utils#file_info()<CR>',                       'Show file info' },
    s = { ':write<CR>',                                              'Save current file' },
    S = { ':wa<CR>',                                                 'Save all file' },
    y = { ':call hasan#utils#CopyFileNameToClipBoard(1)<CR>',        'Yank path name' },
    Y = { ':call hasan#utils#CopyFileNameToClipBoard(0)<CR>',        'Yank file name' },
    R = { ':lua require("hasan.utils.ui").rename_current_file()<CR>','Rename file' },
    C = 'Copy this file',
    M = 'Move/rename file',

    -- Word command
    w = { '<Plug>(fix-current-world)',         'Fix current world' },
    ['.'] = {':lua require("hasan.utils.ui").substitute_word(false)<CR>','Substitute word'},

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
    a = 'Org agenda',
    c = 'Org capture',
    h = {'<cmd>lua require("hasan.org").open_org_home("-tabedit")<CR>', 'Open org home'},
    ['.'] = {'<cmd>lua require("hasan.org").open_org_home("edit")<CR>', 'Open org home'},
    ['/'] = common.grep_org_text,

    t = { ':FloatermNew --wintype=normal --height=12<CR>',      'Open terminal split' },
    T = { ':FloatermNew<CR>',                                   'Open terminal popup' },
    q = { '<cmd>call hasan#window#toggle_quickfix(1)<CR>',      'Open Quickfix list' },
    l = { '<cmd>call hasan#window#toggle_quickfix(0)<CR>',      'Open Local list' },
    f = { ':FloatermNew --height=1.0 --width=1.0 --opener=edit lf<CR>',     'Open lf' },
    y = { ':lua require("yanklist").yanklist({initial_mode="normal"})<CR>', 'Yank list' },

    b = { '<cmd>call hasan#fern#drawer_toggle(0)<CR>',  'Toggle prject tree' },
    p = { '<cmd>call hasan#fern#drawer_toggle(1)<CR>',  'Toggle prject tree' },
    P = { '<cmd>call hasan#fern#open_dir()<CR>',        'Toggle prject tree' },
    ['-'] = { '<cmd>call hasan#fern#vinager()<CR>',     'Fern vinager' },
  },

  p = {
    name = '+project',
    p = { ':lua require("hasan.telescope.custom").projects()<CR>',            'Switch project' },
    r = { ':lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>','Find recent files' },
    t = { ':lua require("hasan.telescope.custom").search_project_todos()<CR>','Search project todos' },
    -- b = { ':Telescope file_browser prompt_title=Project\\ Browser cwd=~/repoes<CR>',  'Browse other projects' },

    l = { ':SessionLoad<CR>',                       'Load session' },
    s = { ':SessionSave<CR>',                       'Save session' },
    q = { ':SessionSaveAndQuit<CR>',                'Save session and quit' },
    d = { ':Dashboard<CR>',                         'Open dashboard' },

    R = { ':lua require("hasan.project_run").scriptsCommandsFromJSON("package.json")<CR>', 'Run project script' },
    e = { ':lua require("hasan.project_run").commands()<CR>',                              'Run project commands' },
    [':'] = 'Run shell command',
    [';'] = 'Send keys',
  },

  t = {
    name = '+toggle',
    b = { ':lua require("hasan.utils.color").toggle_bg_tranparent()<CR>',  'Toggle transparency' },
    B = { ':lua require("hasan.utils.color").toggle_onedark()<CR>',        'Toggle Onedark' },

    c = { ':setlocal cursorcolumn!<CR>',            'cursorcolumn' },
    w = { ':call hasan#utils#toggleWrap()<CR>',     'toggle-wrap' },
    ['*'] = { ':call autohl#_AutoHighlightToggle()<CR>','Highlight same words' },

    t = {
      name  = '+task-and-timer',
      w = { ':Work<CR>',                            'Start work timer' },
      W = { ':Work!<CR>',                           'Start custom timer' },
      s = { ':TimerShow<CR>',                       'Show timer status' },
      p = { ':TimerToggle<CR>',                     'Pause or Paly' },
      b = { ':Break<CR>',                           'Take a break' },
      o = { ':OpenTasks<CR>',                       'Open tasks' },
      u = { ':UpdateCurrentTimer<CR>',              'Update current timer' },
      U = { ':UpdateCurrentStatus<CR>',             'Update current status' },
    }
  },

  v = {
    name = '+vim',
    ['/'] = { ':Telescope help_tags<CR>',       'Search Vim help' },
    l = { ':call logevents#LogEvents_Toggle()<CR>',  'Toggle LogEvents' },
    p = {
      name = '+plugin',
      c = { 'Compile plugin setup' },
      C = { ':PackerClean<CR>',             'Clean plugins' },
      i = { ':PackerInstall<CR>',           'Install plugins' },
      s = { ':PackerStatus<CR>',            'Plugin status' },
      y = { ':PackerSync<CR>',              'Plugin sync' },
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
    m = { '<cmd>ZoomToggle<CR>',         'Toggle window zoom' },

    ['/'] = common.search_wiki_files,
  },

  ['/'] = {
    name = '+search',
    b = { ':Telescope buffers<CR>',         'Find buffers' },
    f = { ':Telescope find_files<CR>',      'Find file' },
    k = { ':Telescope keymaps<CR>',         'Look up keymaps' } ,
    M = { ':Telescope marks<CR>',           'Jump to marks' } ,
    r = { ':Telescope oldfiles<CR>',        'Recent files' },
    t = { ':Telescope filetypes<CR>',       'Change filetypes' },
    s = { ':lua require("hasan.telescope.custom").grep_string()<CR>',         'Grep string' },
    ['/'] = { ':Telescope live_grep<CR>',   'Find file' },
    ['.'] = { ':Telescope resume<CR>',      'Telescope resume' },

    o = common.grep_org_text,
    w = common.search_wiki_files,
    -- m = { ':Bookmarks<CR>',                 'Jump to bookmark' } ,
  },

  y = 'Yank to CB',
  d = 'Delete to CB',
  q = { '<cmd>Quit<CR>',                                  'Close window' },
  r = { '<cmd>call hasan#utils#cycle_numbering()<CR>',    'Cycle number' },
  R = { '<cmd>lua require("nebulous").toggle_win_blur()<CR>',      'Toggle Nebulous' },
  s = { '<cmd>write<CR>',                                 'Save file' },
  x = { '<cmd>call hasan#utils#buffer#_open_scratch_buffer()<CR>',   'Open up scratch buffer' },
  z = { 'za',                                             'Fold/Unfold' },
  m = { ':lua require("harpoon.mark").add_file()<CR>',    'Mark to Harpoon' },

  -- ['.'] = common.buffers_cwd,
  e = {'<cmd>lua require("hasan.org").toggle_org_float()<CR>',  'Toggle org float'},
  ['>'] = common.buffers_all,
  ['<space>'] = { '<cmd>lua require("hasan.telescope.custom").project_files()<cr>', 'Find File in project' },
  ['<tab>'] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', 'Open Harpoon' },
  ['\\'] = { '<cmd>ZenMode<CR>',         'Toggle zen mode' },

  h = { '<C-w>h',                                         'which_key_ignore' },
  j = { '<C-w>j',                                         'which_key_ignore' },
  k = { '<C-w>k',                                         'which_key_ignore' },
  l = { '<C-w>l',                                         'which_key_ignore' },
  ['1'] = { ':lua require("harpoon.ui").nav_file(1)<CR>', 'which_key_ignore'},
  ['2'] = { ':lua require("harpoon.ui").nav_file(2)<CR>', 'which_key_ignore'},
  ['3'] = { ':lua require("harpoon.ui").nav_file(3)<CR>', 'which_key_ignore'},
  ['4'] = { ':lua require("harpoon.ui").nav_file(4)<CR>', 'which_key_ignore'},
  ['5'] = { ':lua require("harpoon.ui").nav_file(5)<CR>', 'which_key_ignore'},
}

local leader_visual = {
  o = {
    name = '+open',
    y = { ':lua require("yanklist").yanklist({is_visual=true,initial_mode="normal"})<CR>', 'Yank list' },
  },
  f = {
    name = '+file',
    ['.'] = {':lua require("hasan.utils.ui").substitute_word(true)<CR>','Substitute word'},
  },
  ['/'] = {
    name = '+search',
    s = { ':lua require("hasan.telescope.custom").grep_string(true)<CR>',         'Grep string' },
  },
}

wk.register(leader, { prefix = '<leader>' })
wk.register(leader_visual, { prefix = '<leader>', mode = 'v' })

-- for i = 0, 10 do
--   leader[tostring(i)] = "which_key_ignore"
-- end
