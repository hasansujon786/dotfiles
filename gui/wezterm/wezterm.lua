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
