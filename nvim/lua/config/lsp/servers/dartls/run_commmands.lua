local lazy = require('flutter-tools.lazy')
local commands = lazy.require('flutter-tools.commands') ---@module "flutter-tools.commands"
local ui = lazy.require('flutter-tools.ui') ---@module "flutter-tools.ui"

-- TODO: Replace telescope
---@alias TelescopeEntry {hint: string, text: string, command: fun(), id: integer}
---@alias CustomOptions {title: string, callback: fun(bufnr: integer)}

local M = {}

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
  opts = vim.tbl_deep_extend('keep', user_opts or {}, opts or {})
  local callback = opts.callback or execute_command

  return vim.tbl_deep_extend('keep', opts or {}, {
    items = items,
    format = format_cmd(get_max_length(items)),
    layout = { preview = false, preset = 'dropdown' },
    confirm = callback,
  })
end

function M.commands(opts)
  local cmds = {}

  if commands.is_running() then
    cmds = {
      {
        id = 'flutter-tools-hot-reload',
        text = 'Hot reload',
        hint = 'Reload a running flutter project',
        command = commands.reload,
      },
      {
        id = 'flutter-tools-hot-restart',
        text = 'Hot restart',
        hint = 'Restart a running flutter project',
        command = commands.restart,
      },
      {
        id = 'flutter-tools-visual-debug',
        text = 'Visual Debug',
        hint = 'Add the visual debugging overlay',
        command = commands.visual_debug,
      },
      {
        id = 'flutter-tools-performance-overlay',
        text = 'Performance Overlay',
        hint = 'Toggle performance overlay',
        command = commands.performance_overlay,
      },
      {
        id = 'flutter-tools-repaint-rainbow',
        text = 'Repaint Rainbow',
        hint = 'Toggle repaint rainbow',
        command = commands.repaint_rainbow,
      },
      {
        id = 'flutter-tools-slow-animations',
        text = 'Slow Animations',
        hint = 'Toggle slow animations',
        command = commands.slow_animations,
      },
      {
        id = 'flutter-tools-quit',
        text = 'Quit',
        hint = 'Quit running flutter project',
        command = commands.quit,
      },
      {
        id = 'flutter-tools-detach',
        text = 'Detach',
        hint = 'Quit running flutter project but leave the process running',
        command = commands.detach,
      },
      {
        id = 'flutter-tools-inspect-widget',
        text = 'Inspect Widget',
        hint = 'Toggle the widget inspector',
        command = commands.inspect_widget,
      },
      {
        id = 'flutter-tools-paint-baselines',
        text = 'Paint Baselines',
        hint = 'Toggle paint baselines',
        command = commands.paint_baselines,
      },
    }
  else
    cmds = {
      {
        id = 'flutter-tools-run',
        text = 'Run',
        hint = 'Start a flutter project',
        command = commands.run,
      },
    }
  end

  vim.list_extend(cmds, {
    {
      id = 'flutter-tools-pub-get',
      text = 'Pub get',
      hint = 'Run pub get in the project directory',
      command = commands.pub_get,
    },
    {
      id = 'flutter-tools-pub-upgrade',
      text = 'Pub upgrade',
      hint = 'Run pub upgrade in the project directory',
      command = commands.pub_upgrade,
    },
    {
      id = 'flutter-tools-list-devices',
      text = 'List Devices',
      hint = 'Show the available physical devices',
      command = require('flutter-tools.devices').list_devices,
    },
    {
      id = 'flutter-tools-list-emulators',
      text = 'List Emulators',
      hint = 'Show the available emulator devices',
      command = require('flutter-tools.devices').list_emulators,
    },
    {
      id = 'flutter-tools-open-outline',
      text = 'Open Outline',
      hint = 'Show the current files widget tree',
      command = require('flutter-tools.outline').open,
    },
    {
      id = 'flutter-tools-generate',
      text = 'Generate',
      hint = 'Generate code',
      command = commands.generate,
    },
    {
      id = 'flutter-tools-clear-dev-log',
      text = 'Clear Dev Log',
      hint = 'Clear previous logs in the output buffer',
      command = require('flutter-tools.log').clear,
    },
    {
      id = 'flutter-tools-install-app',
      text = 'Install app',
      hint = 'Install a Flutter app on an attached device.',
      command = require('flutter-tools.commands').install,
    },
    {
      id = 'flutter-tools-uninstall-app',
      text = 'Uninstall app',
      hint = 'Uninstall the app if already on the device.',
      command = require('flutter-tools.commands').uninstall,
    },
  })

  local dev_tools = require('flutter-tools.dev_tools')

  if dev_tools.is_running() then
    vim.list_extend(cmds, {
      {
        id = 'flutter-tools-copy-profiler-url',
        text = 'Copy Profiler Url',
        hint = 'Copy the profiler url to the clipboard',
        command = commands.copy_profiler_url,
      },
      {
        id = 'flutter-tools-open-dev-tools',
        text = 'Open Dev Tools',
        hint = 'Open flutter dev tools in the browser',
        command = commands.open_dev_tools,
      },
    })
  else
    vim.list_extend(cmds, {
      {
        id = 'flutter-tools-start-dev-tools',
        text = 'Start Dev Tools',
        hint = 'Open flutter dev tools in the browser',
        command = require('flutter-tools.dev_tools').start,
      },
    })
  end

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
