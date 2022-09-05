vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_preview_pipeline = 'lolcat'
vim.g.dashboard_enable_session = 0
vim.g.dashboard_custom_footer = { '' }
-- vim.g.dashboard_session_directory = 'C:\\Users\\hasan\\dotfiles'
-- \ 'repeat(" ", (winwidth(0) / 2) - (longest_line / 2)) . v:val')

vim.g.dashboard_custom_header = {
  [[       ,               /*        ]],
  [[     ,//,              *##*,     ]],
  [[   ,((((//,            /####%*   ]],
  [[ ,((((((////,          /######%. ]],
  [[ ///((((((((((,        *#######. ]],
  [[ //////(((((((((,      *#######. ]],
  [[ //////(/(((((((((,    *#######. ]],
  [[ //////(. /(((((((((,  *#######. ]],
  [[ //////(.   (((((((((*,*#######. ]],
  [[ //////(.    ,#((((((((########. ]],
  [[ /////((.      /#((((((##%%####. ]],
  [[ (((((((.        .(((((#####%%#. ]],
  [[  /(((((.          ((((#%#%%/*   ]],
  [[    ,(((.            /(%%#*      ]],
  [[       *               *         ]],
  [[                                 ]],
  [[         -- aim lower --         ]],
}

vim.g.dashboard_custom_section = {
  a = {
    description = { '  Recent project files                  SPC p r' },
    command = 'lua require("telescope.builtin").oldfiles({cwd_only = true})',
  },
  b = {
    description = { '  Load last session                     SPC p l' },
    command = 'SessionLoad',
  },
  d = {
    description = { '  Find project file                     SPC f f' },
    command = 'Telescope find_files',
  },
  c = {
    description = { '  Open terminal split                   SPC o t' },
    command = 'FloatermNew --wintype=normal --height=10 bash',
  },
  -- e = {
  --   description = {'  Search  in  project                   SPC / /'},
  --   command = 'Telescope live_grep'
  -- },
  -- f = {
  --   description = {'  Jump to bookmarks WIP                 SPC / m'},
  --   command = ':e wip'
  -- },
}
