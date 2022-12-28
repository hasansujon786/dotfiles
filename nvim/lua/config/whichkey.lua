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

local common = {
  search_wiki_files = { '<cmd>lua require("hasan.telescope.custom").search_wiki_files()<CR>', 'Search org files'},
  grep_org_text = { '<cmd>lua require("hasan.telescope.custom").grep_org_text()<CR>',         'Grep org text'},
  buffers_cwd = { '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>',             'Switch buffers' },
  buffers_all = { '<cmd>lua require("hasan.telescope.custom").buffers(false)<CR>',            'Switch all buffers' },
  grep_string = { '<cmd>lua require("hasan.telescope.custom").grep_string()<CR>',             'Grep string' },
  substitute_word = {'<cmd>lua require("hasan.utils.ui").substitute_word()<CR>',              'Substitute word'},
  project_files = { '<cmd>lua require("hasan.telescope.custom").project_files()<cr>',         'Find project file' },
}
local w = {
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

  ['/'] = common.search_wiki_files,
}

local leader = {
  a = {
    name = '+lsp',
    p = { '<cmd>lua require("telescope.builtin").lsp_definitions({ jump_type = "never" })<CR>',   'Preview defination' },
    r = { '<cmd>lua require("telescope.builtin").lsp_references()<CR>',                           'Preview references' },
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
    name = '+change',
    c = { '<Plug>ColorConvertCycle',                'Cycle color' },
    x = { '<Plug>ColorConvertHEX',                  'Convert color to HEX' },
    h = { '<Plug>ColorConvertHSL',                  'Convert color to HSL' },
    r = { '<Plug>ColorConvertRGB',                  'Convert color to RGB' },
    p = { '<cmd>CccPick<cr>',                       'Pick a color' },

    w = common.substitute_word,

    m = {
      name = '+hightlight-hints',
      x = { '<cmd>call hiiw#ClearInterestingWord()<cr>',          'Clear hints' },
      y = { '<cmd>call hiiw#HiInterestingWord(1)<cr>',            'Mark hint 1' },
      g = { '<cmd>call hiiw#HiInterestingWord(2)<cr>',            'Mark hint 2' },
      b = { '<cmd>call hiiw#HiInterestingWord(3)<cr>',            'Mark hint 3' },
      w = { '<cmd>call hiiw#HiInterestingWord(4)<cr>',            'Mark hint 4' },
      p = { '<cmd>call hiiw#HiInterestingWord(5)<cr>',            'Mark hint 5' },
      r = { '<cmd>call hiiw#HiInterestingWord(6)<cr>',            'Mark hint 6' },
    }
  },

  d = {
    name = 'Debug',
    s = { '<cmd>lua require"dap".continue()<cr>',          'Start' },
  },

  i = {
    name = '+insert',
    d = { '<cmd>call _#Insertion(strftime("%e %B %Y"))<CR>',             'Current date' },
    t = { '<cmd>call _#Insertion(strftime("%H:%M"))<CR>',                'Current time' },
    f = { '<cmd>call _#Insertion(expand("%:~"))<CR>',                    'Current file path' },
    F = { '<cmd>call _#Insertion(expand("%:t"))<CR>',                    'Current file name' },
    e = { '<cmd>lua require("hasan.telescope.custom").emojis()<CR>', 'Insert emoji' },
    l = {
      t = { '<cmd>call _#Insertion(hasan#utils#placeholderImgTag("300x200"))<CR>', 'Placeholder image tag' },
      k = { '<cmd>call _#Insertion("https://placekitten.com/g/50/50")<CR>',        'Sample image link' },
    },
  },

  g = {
    name = '+git',
    ['/'] = { '<cmd>Telescope git_status<CR>',         'Find git files*' },
    c = { '<cmd>Telescope git_commits<CR>',            'Look up commits' },
    C = { '<cmd>Telescope git_bcommits<CR>',           'Look up buffer commits' },
    n = { '<cmd>Telescope git_branches<CR>',           'Checkout git branch' },

    b = { '<cmd>lua require("hasan.utils.init").open_git_remote(true)<CR>',    'Browse git repo' },
    B = { '<cmd>lua require("hasan.utils.init").open_git_remote(false)<CR>',   'Browse git repo' },

    g = { '<cmd>Neogit<CR>',                                                    'Open Neogit' },
    l = { '<cmd>FloatermNew --height=1.0 --width=1.0 lazygit<CR>',              'Open lazygit' },
    t = { '<cmd>FloatermNew --height=1.0 --width=1.0 tig<CR>',                  'Open tig' },

    p = 'Preview hunk',
    s = 'Stage hunk',
    r = 'Reset hunk',
    R = 'Reset buffer',
    u = 'Undo last hunk',
    L = { '<cmd>GitGutterLineHighlightsToggle<CR>',    'Highlight hunks' },
    T = { '<cmd>GitGutterToggle<CR>',                  'Toggle Signes' },
    ['.'] = { '<cmd>silent !git add %<CR>',            'Stage current file' },
    -- f = { '<cmd>diffget //2<cr>',                      'diffget ours' },
    -- j = { '<cmd>diffget //3<CR>',                      'diffget theirs' },
  },

  f = {
    name = '+file',
    -- File Command
    b = { '<cmd>lua require("hasan.telescope.custom").file_browser()<cr>',          'Browser project files' },
    B = { '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>', 'Browse file directory' },
    f = { '<cmd>Telescope find_files<CR>',                                          'Find file' },
    F = { ':Telescope find_files cwd=<C-R>=expand("%:h")<CR><CR>',                  'Find file from here' },
    p = common.project_files,
    ['.'] = { ':Telescope find_files cwd=<C-R>=expand("%:h")<CR><CR>',              'Find file from here' },

    i = { '<cmd>call hasan#utils#file_info()<CR>',                       'Show file info' },
    s = { '<cmd>call hasan#utils#buffer#_save()<cr>',                    'Save current file' },
    S = { '<cmd>wa<CR>',                                                 'Save all file' },
    y = { '<cmd>call hasan#utils#CopyFileNameToClipBoard(1)<CR>',        'Yank path name' },
    Y = { '<cmd>call hasan#utils#CopyFileNameToClipBoard(0)<CR>',        'Yank file name' },
    R = { '<cmd>lua require("hasan.utils.ui").rename_current_file()<CR>','Rename file' },
    e = 'Edit in current dir',
    C = 'Copy this file',
    M = 'Move/rename file',
    X = { '<cmd>call hasan#autocmd#trimWhitespace()<CR>',            'Remove white space'},

    w  = { '<Plug>(fix-current-world)',        'Fix current world' },

    u = {
      name = '+update-permission',
      x = { '<cmd>Chmod +x<CR>',                   'Make this file executable' },
      X = { '<cmd>Chmod -x<CR>',                   'Remove executable' },
      w = { '<cmd>Chmod +w<CR>',                   'Add write permission' },
      W = { '<cmd>Chmod -w<CR>',                   'Remove write permission' },
    },
  },

  o = {
    name = '+open',
    ['/'] = common.grep_org_text,
    a = { loadOrgMode('<space>oa'),                                             'Org agenda' },
    c = { loadOrgMode('<space>oc'),                                             'Org capture' },
    h = {'<cmd>lua require("hasan.org").open_org_home("-tabedit")<CR>',         'Open org home'},

    o = { '<cmd>SymbolsOutline<cr>', 'SymbolsOutline' },
    t = { '<cmd>FloatermNew --wintype=normal --height=12<CR>',                  'Open terminal split' },
    T = { '<cmd>FloatermNew<CR>',                                               'Open terminal popup' },
    q = { '<cmd>call hasan#window#toggle_quickfix(1)<CR>',                      'Open Quickfix list' },
    l = { '<cmd>call hasan#window#toggle_quickfix(0)<CR>',                      'Open Local list' },
    f = { '<cmd>FloatermNew --height=1.0 --width=1.0 --opener=edit lf<CR>',     'Open lf' },
    y = { '<cmd>lua require("yanklist").yanklist({initial_mode="normal"})<CR>', 'Yank list' },
  },

  p = {
    name = '+project',
    c = { '<cmd>lua require("telescope._extensions").manager.project_commands.commands()<CR>',   'Run project commands' },

    p = { '<cmd>lua require("hasan.telescope.custom").projects()<CR>',            'Switch project' },
    r = { '<cmd>lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>','Find recent files' },
    t = { '<cmd>lua require("hasan.telescope.custom").search_project_todos()<CR>','Search project todos' },
    -- b = { '<cmd>Telescope file_browser prompt_title=Project\\ Browser cwd=~/repoes<CR>',  'Browse other projects' },

    d = { '<cmd>Alpha<CR>',                             'Open dashboard' },
    l = { '<cmd>SessionLoad<CR>',                       'Load session' },
    s = { '<cmd>SessionSave<CR>',                       'Save session' },
    m = { '<cmd>lua require("config.persisted").loadSession()<CR>',       'Show session menu' },
    z = { '<cmd>lua require("config.persisted").sessionSaveAndQuit()<CR>','Save session and quit' },
  },

  t = {
    name = '+toggle',
    b = { '<cmd>lua require("hasan.utils.color").toggle_bg_tranparent()<CR>',  'Toggle transparency' },
    B = 'Toggle Onedark',

    l = { '<cmd>lua require("hasan.utils").toggle("cursorcolumn")<CR>',    'Toggle cursorcolumn' },
    L = { '<cmd>lua require("hasan.utils").toggle("cursorline")<CR>',      'Toggle cursorline' },
    h = { '<cmd>call autohl#_AutoHighlightToggle()<CR>',                   'Highlight same words' },
    s = { '<cmd>lua require("hasan.utils").toggle("spell")<CR>',           'Toggle spell' },
    w = { '<cmd>lua require("hasan.utils").toggle("wrap")<CR>',            'Toggle wrap' },

    t = {
      name  = '+task-and-timer',
      q = { '<cmd>TimerStop<CR>',                       'Quit the timer' },
      w = { '<cmd>Work<CR>',                            'Start work timer' },
      W = { '<cmd>Work!<CR>',                           'Start custom timer' },
      s = { '<cmd>TimerShow<CR>',                       'Show timer status' },
      p = { '<cmd>TimerToggle<CR>',                     'Pause or Paly' },
      b = { '<cmd>Break<CR>',                           'Take a break' },
      o = { '<cmd>OpenTasks<CR>',                       'Open tasks' },
      u = { '<cmd>UpdateCurrentTimer<CR>',              'Update current timer' },
      U = { '<cmd>UpdateCurrentStatus<CR>',             'Update current status' },
    }
  },

  v = {
    name = '+vim',
    ['/'] = { '<cmd>Telescope help_tags<CR>',              'Search Vim help' },
    ['.'] = { '<cmd>echo "Not a Vim file"<CR>',            'Source this file' },
    l = { '<cmd>call logevents#LogEvents_Toggle()<CR>',    'Toggle LogEvents' },
    R = { '<cmd>ReloadConfig<CR>',                         'Reload neovim' },
    H = { '<cmd>silent write | edit | TSBufEnable highlight<CR>', 'Reload hightlight' },
    p = { '<cmd>Lazy home<CR>',            'Plugin status' },
    P = { '<cmd>lua require("hasan.telescope.custom").search_plugins()<CR>', 'Search plugin files'},
  },

  w = w,

  ['/'] = {
    name = '+search',
    ['.'] = { '<cmd>Telescope resume<cr>',      'Telescope resume' },
    b = { '<cmd>Telescope buffers<CR>',         'Find buffers' },
    f = { '<cmd>Telescope find_files<CR>',      'Find file' },
    k = { '<cmd>Telescope keymaps<CR>',         'Look up keymaps' } ,
    M = { '<cmd>Telescope marks<CR>',           'Jump to marks' } ,
    r = { '<cmd>Telescope oldfiles<CR>',        'Recent files' },
    t = { '<cmd>Telescope filetypes<CR>',       'Change filetypes' },

    o = common.grep_org_text,
    w = common.search_wiki_files,

    s = common.grep_string,
    ['/'] = { '<cmd>Telescope live_grep<CR>',   'Live grep' },
    g = { '<cmd>lua require("hasan.telescope.custom").live_grep_in_folder()<cr>', 'Live grep in folder' },
    -- m = { '<cmd>Bookmarks<CR>',                 'Jump to bookmark' } ,
  },

  q = { '<cmd>Quit<CR>',                                               'Close window' },
  r = { '<cmd>lua require("hasan.utils.ui").cycle_numbering()<CR>',    'Cycle number' },
  R = { '<cmd>lua require("nebulous").toggle_win_blur()<CR>',          'Toggle Nebulous' },
  s = { '<cmd>call hasan#utils#buffer#_save()<cr>',                    'Save file' },
  x = { '<cmd>call hasan#utils#buffer#_open_scratch_buffer()<CR>',     'Scratch buffer' },
  M = { '<cmd>lua require("harpoon.mark").add_file()<CR>',             'Mark to Harpoon' },

  -- ['.'] = common.buffers_cwd,
  e = {'<cmd>lua require("hasan.org").toggle_org_float()<CR>',         'Toggle org float'},
  ['<tab>'] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', 'Open Harpoon' },
  ['<space>'] = common.project_files,
  ['>'] = common.buffers_all,
  ['.'] = common.buffers_cwd,

  h = { '<C-w>h', 'which_key_ignore' },
  j = { '<C-w>j', 'which_key_ignore' },
  k = { '<C-w>k', 'which_key_ignore' },
  l = { '<C-w>l', 'which_key_ignore' },
}

local leader_visual = {
  o = {
    name = '+open',
    y = { '<cmd>lua require("yanklist").yanklist({is_visual=true,initial_mode="normal"})<CR>', 'Yank list' },
  },
  c = {
    name = '+change',
    w = common.substitute_word,
  },
  w = w,
  ['/'] = {
    name = '+search',
    s = common.grep_string,
  },

  h = { '<C-w>h', 'which_key_ignore' },
  j = { '<C-w>j', 'which_key_ignore' },
  k = { '<C-w>k', 'which_key_ignore' },
  l = { '<C-w>l', 'which_key_ignore' },
}

for i = 0, 9 do
  leader[tostring(i)] = { 'which_key_ignore' }
  local harpoon_rs = '<cmd>lua require("harpoon.ui").nav_file(%s)<CR>'
  local harpoon_ls = '<leader>%s'
  keymap('n', harpoon_ls:format(i), harpoon_rs:format(i))

  leader.w[tostring(i)] = { 'which_key_ignore' }
  local win_ls = '<leader>w%s'
  local win_rs = '%s<C-w>w'
  keymap('n', win_ls:format(i), win_rs:format(i))
end

wk.register(leader, { prefix = '<leader>' })
wk.register(leader_visual, { prefix = '<leader>', mode = 'v' })
