local _utils = require('hasan.utils')
local utils = require('nebulous.utils')
local view = require('nebulous.view')
local config = require('nebulous.configs')

local M = {}

M.update_all_windows = view.update_all_windows

M.on_focus_lost = function()
  -- local win_id = vim.api.nvim_get_current_win()
  -- view.blurWindow(win_id)
  vim.cmd([[hi Cursor blend=100]])
end

M.on_focus_gained = function()
  -- local win_id = vim.api.nvim_get_current_win()
  -- view.focusWindow(win_id)
  vim.cmd([[hi Cursor blend=0]])
end

M.toggle = function()
  if config.options.nb_is_disabled or config.options.is_win_blur_disabled then
    M.init()
    print('[Nebulous] on')
  else
    view.disable()
    print('[Nebulous] off')
  end
end

M.toggle_win_blur = function()
  if config.options.is_win_blur_disabled or config.options.nb_is_disabled then
    M.init()
    print('[Nebulous] win blur on')
  else
    view.disable_win_blur()
    print('[Nebulous] win blur off')
  end
end

M.pause = function(time, auto_dispose)
  config.options.is_win_blur_disabled = true

  if auto_dispose or auto_dispose == nil then
    vim.defer_fn(function()
      config.options.is_win_blur_disabled = false
    end, time or 1000)
  end
end

M.init = function(init_state)
  config.options.nb_is_disabled = false
  config.options.is_win_blur_disabled = _utils.get_default(init_state, false)
  utils.setup_colors()
  vim.fn['nebulous#autocmds']()
  view.update_all_windows()
end

M.setup = function(opts)
  opts = _utils.merge(config.default, opts or {})
  config.updateConfigs(opts)

  M.init(opts.init_wb_with_disabled)
end

return M
