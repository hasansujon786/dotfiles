-- italic = false, -- Specify whether you want the text to be italic (true) or not (false)
-- strikethrough = false, -- Specify whether you want the text to be rendered with strikethrough (true)
-- intensity = 'Bold', -- Specify whether you want 'Half', 'Normal' or 'Bold' intensity for the
-- underline = 'None', -- Specify whether you want 'None', 'Single' or 'Double' underline for

-- local mapkey = function(mods, key, action)
--     config.keys[#config.keys + 1] = {key = key, mods = mods, action = action}
-- end

-- mapkey(
--     'CTRL|ALT|SHIFT',
--     'w',
--     wezterm.action_callback(
--         function(window, pane)
--             WALLPAPER_LAST_CHANGED = os.time()
--             -- set a new one
--             local overrides = window:get_config_overrides() or {}
--             overrides.window_background_image = random_wallpaper()
--             window:set_config_overrides(overrides)
--         end
--     )
-- )

-- CMD-y starts `top` in a new window
-- wezterm cli split-pane --horizontal
-- wezterm cli spawn --window-id=0
-- wezterm cli spawn lf

-- if tab_is_toolbox then
--   title = "🔴 " .. title
-- end

-- {'wezterm', 'lf', function (util)
--   -- local cmd = {
--   --   [[silent !start wezterm-gui]],
--   --   [[--config enable_tab_bar=false --config window_background_opacity=0.9]],
--   --   [[start --cwd .]]
--   -- }

--   local cmd = {
--     -- [[!wezterm cli split-pane --cwd .]],
--     [[!wezterm cli spawn flutter run ]],
--   }

--   -- local cmd = {
--   --   -- [[!wezterm cli split-pane --cwd .]],
--   --   [[!wezterm cli spawn --cwd . \ lf]],
--   -- }

--   -- wezterm cli spawn --window-id=0
--   vim.cmd(table.concat(cmd, ' '))
-- end},
-- {'flutter run', 'flutter run', function (util)
--   util.open_tab(vim.fn.getcwd(), 'flutter run')
-- end},

-- {'wezterm', 'lf', function (util)

--   local cmd = {
--     [[silent !start wezterm-gui]],
--     [[--config enable_tab_bar=false --config window_background_opacity=0.9]],
--     [[start --cwd . lf]]
--   }

--   -- local cmd = {
--   --   -- [[!wezterm cli split-pane --cwd .]],
--   --   [[!wezterm cli spawn --cwd . \ lf]],
--   -- }

--   -- wezterm cli spawn --window-id=0
--   vim.cmd(table.concat(cmd, ' '))
-- end},
-- {'lazygit', 'lazygit', function (util)
--   util.open_tab(vim.fn.getcwd(), 'source ~/dotfiles/bash/.bashrc && lazygit')
-- end},
-- {'lf', 'lf', function (util)
--   util.open_tab(vim.fn.getcwd(), 'source ~/dotfiles/bash/.bashrc && lf')

-- if tab_is_toolbox then
--   title = "🔴 " .. title
-- end

local TAB_EDGE_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick
local TAB_EDGE_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick

local function tab_title(tab_info)
  local title = tab_info.tab_title

  if title and #title > 0 then
    return title
  end

  return tab_info.active_pane.title:gsub('%.exe', '')
end

wezterm.on('format-tab-title', function(tab, _, _, _, hover, max_width)
  local edge_background = title_color_bg
  local background = title_color_bg:lighten(0.05)
  local foreground = title_color_fg

  if tab.is_active then
    background = background:lighten(0.1)
    foreground = foreground:lighten(0.1)
  elseif hover then
    background = background:lighten(0.2)
    foreground = foreground:lighten(0.2)
  end

  local edge_foreground = background

  local title = tab_title(tab)

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  title = wezterm.truncate_right(title, max_width - 2)

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = TAB_EDGE_LEFT },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = TAB_EDGE_RIGHT },
  }
end)

-- sessionizer.lua --------------------------------------------------
--- If name nil or false print err_message
---@param name string|boolean|nil
---@param err_message string
local function err_if_not(name, err_message)
  if not name then
    w.log_error(err_message)
  end
end
--
--- path if file or directory exists nil otherwise
---@param path string
local function file_exists(path)
  if path == nil then
    return nil
  end
  local f = io.open(path, 'r')
  -- io.open won't work to check if directories exist,
  -- but works for symlinks and regular files
  if f ~= nil then
    w.log_info(path .. ' file or symlink found')
    io.close(f)
    return path
  end
  return nil
end

-------------------------------------------------------
-- PATHS
--
local fd = (
  file_exists('/ProgramData/chocolatey/bin/fd.exe')
  or file_exists(home .. '/bin/fd')
  or file_exists('usr/bin/fd')
  or file_exists(home .. '/bin/fd.exe')
)
err_if_not(fd, 'fd not found')

local git = (file_exists('/Program Files/Git/cmd/git.exe') or file_exists('/usr/bin/git'))
err_if_not(git, 'git not found')
-------------------------------------------------------
