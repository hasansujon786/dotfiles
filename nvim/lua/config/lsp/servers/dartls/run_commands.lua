local lazy = require('flutter-tools.lazy')
local ui = lazy.require('flutter-tools.ui') ---@module "flutter-tools.ui"

-- TODO: Replace telescope
---@alias TelescopeEntry {hint: string, text: string, command: fun(), id: integer}
---@alias CustomOptions {title: string, callback: fun(bufnr: integer)}

local ft_commands = lazy.require('flutter-tools.commands') ---@module "flutter-tools.commands"
local devices = lazy.require('flutter-tools.devices') ---@module "flutter-tools.devices"
local outline = lazy.require('flutter-tools.outline') ---@module "flutter-tools.outline"
local ft_log = lazy.require('flutter-tools.log') ---@module "flutter-tools.log"
local dev_tools = lazy.require('flutter-tools.dev_tools') ---@module "flutter-tools.dev_tools"

local M = {}

-- stylua: ignore
local commands_data = {
  -- Running-only commands
  { text = 'Hot reload', key = 'r', id = 'flutter-tools-hot-reload', hint = 'Reload a running flutter project', cmd = 'reload', when = 'running' },
  { text = 'Hot restart', key = 'R', id = 'flutter-tools-hot-restart', hint = 'Restart a running flutter project', cmd = 'restart', when = 'running' },
  { text = 'Quit', key = 'q',  id = 'flutter-tools-quit', hint = 'Quit running flutter project', cmd = 'quit', when = 'running' },
  { text = 'Detach', key = 'd',  id = 'flutter-tools-detach', hint = 'Quit running flutter project but leave the process running', cmd = 'detach', when = 'running' },

  -- Running-only commands (Visual debug)
  { text = 'Construction lines', key = 'p', id = 'flutter-tools-visual-debug', hint = 'Toggle the display of construction lines', cmd = 'visual_debug', when = 'running' },
  { text = 'Performance Overlay', key = 'P', id = 'flutter-tools-performance-overlay', hint = 'Toggle performance overlay', cmd = 'performance_overlay', when = 'running' },
  { text = 'Screenshot', key = 'S', id = 'flutter-tools-screenshot', hint = 'Save a screenshot to flutter.png', cmd = 'screenshot', when = 'running' },
  { text = 'Repaint Rainbow', id = 'flutter-tools-repaint-rainbow', hint = 'Toggle repaint rainbow', cmd = 'repaint_rainbow', when = 'running' },
  { text = 'Slow Animations', id = 'flutter-tools-slow-animations', hint = 'Toggle slow animations', cmd = 'slow_animations', when = 'running' },
  { text = 'Inspect Widget', key = 'i', id = 'flutter-tools-inspect-widget', hint = 'Toggle the widget inspector', cmd = 'inspect_widget', when = 'running' },
  { text = 'Paint Baselines', id = 'flutter-tools-paint-baselines', hint = 'Toggle paint baselines', cmd = 'paint_baselines', when = 'running' },

  -- Not-running commands
  { text = 'Run', id = 'flutter-tools-run', hint = 'Start a flutter project', cmd = 'run', when = 'not_running' },

  -- Always-available commands
  { text = 'Pub get', id = 'flutter-tools-pub-get', hint = 'Run pub get in the project directory', cmd = 'pub_get', when = 'always' },
  { text = 'Pub upgrade', id = 'flutter-tools-pub-upgrade', hint = 'Run pub upgrade in the project directory', cmd = 'pub_upgrade', when = 'always' },
  { text = 'List Devices', id = 'flutter-tools-list-devices', hint = 'Show the available physical devices', cmd = 'devices.list_devices', when = 'always' },
  { text = 'List Emulators', id = 'flutter-tools-list-emulators', hint = 'Show the available emulator devices', cmd = 'devices.list_emulators', when = 'always' },
  { text = 'Generate', key = 'g', id = 'flutter-tools-generate', hint = 'Generate code', cmd = 'generate', when = 'always' },
  { text = 'Install app', id = 'flutter-tools-install-app', hint = 'Install a Flutter app on an attached device.', cmd = 'install', when = 'always' },
  { text = 'Show Logs', id = 'flutter-tools-log-toggle', hint = 'Toggle Log Window', cmd = 'log.toggle', when = 'always' },
  { text = 'Clear Logs', id = 'flutter-tools-clear-dev-log', hint = 'Clear previous logs in the output buffer', cmd = 'log.clear', when = 'always' },
  { text = 'Uninstall app', id = 'flutter-tools-uninstall-app', hint = 'Uninstall the app if already on the device.', cmd = 'uninstall', when = 'always' },
  { text = 'Open Outline', id = 'flutter-tools-open-outline', hint = 'Show the current files widget tree', cmd = 'outline.open', when = 'always' },

  -- Dev tools commands
  { text = 'Copy Profiler Url', id = 'flutter-tools-copy-profiler-url', hint = 'Copy the profiler url to the clipboard', cmd = 'copy_profiler_url', when = 'dev_tools_running' },
  { text = 'Open Dev Tools', key = 'v', id = 'flutter-tools-open-dev-tools', hint = 'Open flutter dev tools in the browser', cmd = 'open_dev_tools', when = 'dev_tools_running' },
  { text = 'Start Dev Tools', id = 'flutter-tools-start-dev-tools', hint = 'Open flutter dev tools in the browser', cmd = 'dev_tools.start', when = 'dev_tools_not_running' },
}

local function resolve_command(cmd)
  if cmd == 'devices.list_devices' then
    return devices.list_devices
  elseif cmd == 'devices.list_emulators' then
    return devices.list_emulators
  elseif cmd == 'screenshot' then
    return require('config.lsp.servers.dartls.flutter_screenshot').screenshot
  elseif cmd == 'outline.open' then
    return outline.open
  elseif cmd == 'log.toggle' then
    return ft_log.toggle
  elseif cmd == 'log.clear' then
    return ft_log.clear
  elseif cmd == 'dev_tools.start' then
    return dev_tools.start
  else
    return ft_commands[cmd]
  end
end

local function execute_command(p, item)
  p:close()
  local cmd = item.command
  if cmd then
    local success, msg = pcall(cmd)
    if not success then
      ui.notify(msg, ui.ERROR)
    end
  end
end

local function format_cmd(max_width)
  return function(item, _)
    local has_hint = item.hint and item.hint ~= ''
    local ret = {} ---@type snacks.picker.Highlight[]

    ret[#ret + 1] = { item.key and string.format('%s ', item.key) or '  ' }

    ret[#ret + 1] = { item.text, 'Type' }
    local w = vim.api.nvim_strwidth(item.text)
    ret[#ret + 1] = { (' '):rep(max_width - w) }

    if has_hint then
      ret[#ret + 1] = { ' • ' }
      ret[#ret + 1] = { item.hint, 'Comment' }
    end
    return ret
  end
end

local function get_max_length(cmds)
  local max = 0
  for _, value in ipairs(cmds) do
    max = #value.text > max and #value.text or max
  end
  return max
end

---The options use to create the custom telescope picker menu's for flutter-tools
---@param items TelescopeEntry[]
---@param user_opts table?
---@param opts CustomOptions?
function M.get_config(items, user_opts, opts)
  local callback = (opts and opts.callback) or execute_command

  local config = vim.tbl_deep_extend('force', {
    items = items,
    format = format_cmd(get_max_length(items)),
    layout = { preview = false, preset = 'select' },
    confirm = callback,
  }, user_opts or {}, opts or {})

  config.callback = nil
  return config
end

function M.commands(opts)
  local is_running = ft_commands.is_running()
  local is_dev_tools_running = dev_tools.is_running()

  local cmds = vim
    .iter(commands_data)
    :filter(function(entry)
      return entry.when == 'always'
        or (entry.when == 'running' and is_running)
        or (entry.when == 'not_running' and not is_running)
        or (entry.when == 'dev_tools_running' and is_dev_tools_running)
        or (entry.when == 'dev_tools_not_running' and not is_dev_tools_running)
    end)
    :map(function(entry)
      return {
        text = entry.text,
        id = entry.id,
        hint = entry.hint,
        key = entry.key,
        command = resolve_command(entry.cmd),
      }
    end)
    :totable()

  Snacks.picker.pick(M.get_config(cmds, opts, { title = 'Flutter tools commands' }))
end

-- local function execute_fvm_use(bufnr)
--   local selection = action_state.get_selected_entry()
--   actions.close(bufnr)
--   local cmd = selection.command
--   if cmd then
--     local success, msg = pcall(cmd, selection.ordinal)
--     if not success then
--       ui.notify(msg, ui.ERROR)
--     end
--   end
-- end

-- function M.fvm(opts)
--   commands.fvm_list(function(sdks)
--     opts = opts and not vim.tbl_isempty(opts) and opts
--       or themes.get_dropdown({
--         previewer = false,
--         layout_config = {
--           height = #sdks + MENU_PADDING,
--         },
--       })

--     local sdk_entries = {}
--     for _, sdk in pairs(sdks) do
--       table.insert(sdk_entries, {
--         id = sdk.name,
--         label = sdk.name,
--         hint = sdk.dart_sdk_version and '(Dart SDK ' .. sdk.dart_sdk_version .. ')' or '',
--         command = commands.fvm_use,
--       })
--     end

--     pickers
--       .new(M.get_config(sdk_entries, opts, {
--         title = 'Change Flutter SDK',
--         callback = execute_fvm_use,
--       }))
--       :find()
--   end)
-- end

return M

-- h Repeat this help message.
-- a Toggle timeline events for all widget build methods.                    (debugProfileWidgetBuilds)
-- b Toggle platform brightness (dark and light mode).                        (debugBrightnessOverride)
-- o Simulate different operating systems.                                      (defaultTargetPlatform)
-- I Toggle oversized image inversion.                                     (debugInvertOversizedImages)
--
-- w Dump widget hierarchy to the console.                                               (debugDumpApp)
-- t Dump rendering tree to the console.                                          (debugDumpRenderTree)
-- L Dump layer tree to the console.                                               (debugDumpLayerTree)
-- f Dump focus tree to the console.                                               (debugDumpFocusTree)
-- S Dump accessibility tree in traversal order.                                   (debugDumpSemantics)
-- U Dump accessibility tree in inverse hit test order.                            (debugDumpSemantics)
--
