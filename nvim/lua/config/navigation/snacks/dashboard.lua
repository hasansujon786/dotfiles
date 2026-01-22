local btn_width = 42
local function button(key, label, icon, desc, cmd)
  local pad = btn_width - #label - 3

  return {
    text = {
      { icon, hl = 'SnacksDashboardIcon', width = 3 },
      { desc, hl = 'SnacksDashboardDesc', width = pad },
      -- { '', hl = 'SnacksDashboardKeyAlt' },
      { label, hl = 'SnacksDashboardKey' },
      -- { '', hl = 'SnacksDashboardKeyAlt' },
      -- { label, hl = 'SnacksDashboardKey' },
    },
    action = cmd,
    key = key,
    align = 'center',
  }
end
return {
  width = btn_width,
  enabled = not require('core.state').ui.session_autoload,

  formats = {
    icon = function(item)
      if item.file and item.icon == 'file' or item.icon == 'directory' then
        return { '', width = 2, hl = 'SnacksDashboardIcon' }
        -- return Snacks.dashboard.icon(item.file, item.icon)
      end
      return { item.icon, width = 2, hl = 'icon' }
    end,
  },
  -- These settings are used by some built-in sections
  preset = {
    -- Used by the `header` section
    header = [[
    ███  ███       ██████           
    ███  ██         ███  █ █        
   ████ ██          ███ █             
  ████████▀▀▀ ██▀██ ██████████
 ██ ██████■■  ██ ██ ████ █ ████
██  ███ ██▄▄▄ ██▄██ ███ ███████]],
  },
  sections = {
    { section = 'header' },
      -- { section = 'keys', gap = 1, padding = 2 },
      -- stylua: ignore
      {
        {
          gap = 0,
          padding = 1,
          { text = {{ 'Get Started', hl = 'String' }, {' ………………………………………………………………………………', hl = 'SnacksDim'}}},
          button('n', 'n', ' ', 'New File', '<cmd>ene | startinsert<CR>'),
          button('f', '<spc>ff', ' ', 'Search Files', '<cmd>lua Snacks.dashboard.pick("files")<CR>'),
          button('p', '<spc>pp', ' ', 'Open Project', '<cmd>lua require("config.navigation.snacks.persisted").persisted()<CR>'),
          button('l', '<spc>pl', '󰑓 ', 'Load Last Session', '<cmd>lua require("persisted").load()<CR>'),
          -- button('r', 'R', ' ', 'Recent file', '<cmd>lua Snacks.dashboard.pick("recent")<CR>'),
          -- button('t', '<spc>ot', ' ', 'Open Terminal', '<cmd>lua Snacks.terminal(nil,{shell="bash",win={wo={winbar=""}}})<CR>'),
          -- button('a', '<spc>oa', ' ', 'Open org agenda', '<cmd>lua require("orgmode").action("agenda.prompt")<CR>'),
        },
        -- {
        --   gap = 0,
        --   padding = 1,
        --   { text = {{ 'Configure', hl = 'String' }, { ' ……………………………………………………………………………………', hl = 'SnacksDim' }}},
        --   button('s', 's', ' ', 'Open Settings', '<cmd>lua Snacks.dashboard.pick("files",{cwd=vim.fn.stdpath("config")})<CR>'),
        --   button('<leader>vp', '<spc>vp', ' ', 'Lazy Dashboard', '<cmd>Lazy<CR>'),
        --   { text = { { '………………………………………………………………………………………………………………', hl = 'SnacksDim' } } },
        -- },
        { { text = { { 'Recent Projects', hl = 'String' }, { ' ……………………………………………………………………', hl = 'SnacksDim' } } } },
        {
          padding = 1,
          section = 'projects',
          { text = { { '………………………………………………………………………………………………………………', hl = 'SnacksDim' } } },
        },
      },
    {
      function()
        local v = vim.version()
        local patch = v.patch
        if v.prerelease then
          patch = patch .. '-' .. v.prerelease
        end
        return {
          align = 'center',
          width = 30,
          text = {
            { '██', hl = 'SnacksDashboardFooterAlt' },
            { string.format([[v%s.%s.%s]], v.major, v.minor, patch), hl = 'SnacksDashboardFooter' },
            { '██', hl = 'SnacksDashboardFooterAlt' },
          },
        }
      end,
    },
    -- { pane = 2, section = 'recent_files', title = 'Recent files' },
    -- { pane = 2, section = 'projects', title = 'Projects' },
  },
}
