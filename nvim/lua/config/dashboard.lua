vim.g.dashboard_default_executive = "telescope"
vim.g.dashboard_preview_pipeline = "lolcat"
vim.g.dashboard_enable_session = 0
vim.g.dashboard_custom_footer = {''}

vim.g.dashboard_custom_header = {
  [[          /                /*          ]],
  [[       ,(///,              *###*       ]],
  [[     (((((////.            /####%*     ]],
  [[  ,/((((((/////*           /######%,   ]],
  [[  *///(((((//////.         *########.  ]],
  [[  ///////(((((((((*        *########.  ]],
  [[  /////////(((((((((*      *########.  ]],
  [[  /////////,((((((((/(,    *########.  ]],
  [[  ////////. /(((((((((((,  *########.  ]],
  [[  ////////.   ((((((((((((,#########.  ]],
  [[  ////////.     #((((((((((#########.  ]],
  [[  (//////(.      /#((((((((#%%######.  ]],
  [[  ((((((((.        #(((((((###%%##%#.  ]],
  [[  .#((((((.           (((((######%%    ]],
  [[     /((((.            .(((%##%%/*     ]],
  [[       ,((.              /(%%#         ]],
  [[         ..                *           ]],
 }


vim.g.dashboard_custom_section = {
  a = {
    description = {'  Recently used files                   SPC p r'},
    command = 'Telescope oldfiles'
  },
  e = {
    description = {'  Find project files                    SPC f f'},
    command = 'Telescope find_files'
  },
  c = {
    description = {'  Search in project                     SPC / /'},
    command = 'Telescope live_grep'
  },
  f = {
    description = {'  Open terminal split                   SPC o T'},
    command = 'FloatermNew --wintype=normal --height=10 bash'
  },
  -- b = {
  --   description = {'  Load last session WIP                 SPC p l'},
  --   command = 'SessionLoad'
  -- },
  -- d = {
  --   description = {'  Jump to bookmarks WIP                 SPC / m'},
  --   command = ':e wip'
  -- },
}
