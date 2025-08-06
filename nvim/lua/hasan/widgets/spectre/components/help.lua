local ns_help = vim.api.nvim_create_namespace('spectree-nui-help')
local hint_keys = { 'Search', 'Replacement', 'Filter Files', 'Paths' }

local M = {}

local help_popup = nil

---Show help
---@param placeholders any
---@param keymaps {key:string, mode:string[],desc:string}[]
---@param conf {width:number,row:number}
function M.show(placeholders, keymaps, conf)
  if M.close() then
    return
  end

  local event = require('nui.utils.autocmd').event
  local Popup = require('nui.popup')

  local lines = {
    { { 'Hints:', 'Function' } },
  }
  for _, h_key in ipairs(hint_keys) do
    local sep = (' '):rep(18 - #h_key)
    table.insert(lines, { { '- ' }, { h_key, 'String' }, { sep }, { placeholders[h_key], 'Comment' } })
  end

  table.insert(lines, { { 'Keymaps:', 'Function' } })
  for _, map in ipairs(keymaps) do
    local key = map.key .. (' '):rep(11 - #map.key)
    local modes = table.concat(map.mode, ' ')
    local sep = (' '):rep(18 - #key - #modes)

    table.insert(lines, { { '- ' }, { key, 'String' }, { modes, 'Constant' }, { sep }, { map.desc, 'Comment' } })
  end

  local popup = Popup({
    enter = true,
    focusable = true,
    zindex = 60,
    border = { style = 'rounded', text = { bottom = ' Help (press q to close) ' } },
    win_options = {
      winhighlight = 'Normal:NuiComponentsNormal',
      cursorline = false,
    },
    anchor = 'SW',
    relative = 'editor',
    position = { row = conf.row, col = '100%' },
    size = { width = conf.width - 2, height = #lines },
  })

  local bufnr, ns_id, linenr_start = popup.bufnr, ns_help, 0
  require('hasan.utils.buffer').render_lines(bufnr, ns_id, lines, linenr_start)
  popup:mount()

  popup:map('n', 'q', function(_)
    popup:unmount()
  end, { noremap = true })
  popup:map('n', '?', function(_)
    popup:unmount()
  end, { noremap = true })
  popup:map('n', 'i', function(_)
    require('hasan.widgets.spectre').open()
  end, { noremap = true })

  popup:on({ event.WinClosed }, function()
    help_popup = nil
  end, { once = true })

  help_popup = popup
  return popup
end

function M.close()
  if help_popup then
    pcall(function()
      help_popup:unmount()
    end)
    help_popup = nil
    return true
  end
end

return M
