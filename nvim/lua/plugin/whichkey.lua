require("which-key").setup {
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 0, 2, 0 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  show_help = false,
}


local wk = require("which-key")

wk.register({
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

  f = {
    name = "+file", -- optional group name
    f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
    n = { "New File" }, -- just a label. don't create any mapping
    e = "Edit File", -- same as above
    ["1"] = "which_key_ignore",  -- special label to hide it in the popup
    b = { function() print("bar") end, "Foobar" }, -- you can also pass functions!
    s = { "<cmd>w<cr>", "Save file" }, -- create a binding with label
  },

  w = {
    name= '+window',
    v = { '<C-w>v',                                    'VSplit window' },
    s = { '<C-w>s',                                    'Split window' },
    o = { '<C-w>o',                                    'Keep only windwo' },
    c = { '<C-w>c',                                    'Close windows' },
    q = { '<C-w>c',                                    'Close windows' },
    t = { '<cmd>-tab split<CR>',                       'Move to new tab' },
    O = { '<cmd>tabonly<CR>',                          'Keep only tab' },
    z = { '<cmd>AutoZoomWin<CR>',                      'Toggle window zoom' },
  },

  q = { '<cmd>Quit<cr><CR>',                              'Close window' },
  r = { '<cmd>CycleNumber<CR>',                           'Cycle number' },
  R = { '<cmd>call nebulous#toggle()<CR>',                'Toggle Nebulous' },
  s = { '<cmd>write<CR>',                                 'Save file' },
  x = { '<cmd>bdelete<CR>',                               'Delete buffer' },
  z = { 'za',                                             'Fold/Unfold' },

  ['<space>'] = { '<cmd>ProjectFiles<cr>',                'Find File' },
  ['.'] = { '<cmd>Telescope find_files<CR>',              'Find file' },
  [';'] = { '<cmd>Telescope command_history<CR>',         'Search commands' },
  [':'] = { '<cmd>Telescope commands<CR>',                'Search recent cmd' },
  ['<tab>'] = 'which_key_ignore',

  -- ['i']['p'] = 'from-system-clipboard'
  y = 'which_key_ignore',
  d = 'which_key_ignore',
  h = { '<cmd>JumpToWin h<CR>',                           'which_key_ignore' },
  j = { '<cmd>JumpToWin j<CR>',                           'which_key_ignore' },
  k = { '<cmd>JumpToWin k<CR>',                           'which_key_ignore' },
  l = { '<cmd>JumpToWin l<CR>',                           'which_key_ignore' },

}, { prefix = "<leader>" })


