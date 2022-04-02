local _utils = require('hasan.utils')
local utils = require('nebulous.utils')
local view = require('nebulous.view')
local configs = require('nebulous.configs').configs

local fn = vim.fn
local api = vim.api
local M = {}

M.setup_colors = function()
  vim.cmd([[
    " hi! link Nebulous PmenuThumb
    hi Nebulous guifg=#323c4e
    hi EndOfBuffer guibg=NONE
  ]])
end

M.update_all_windows = function(shouldCheckFloat)
  if configs.nb_is_disabled then
    return
  end

  -- check update windows again if there is a floating window
  if utils.is_floting_window(0) and shouldCheckFloat then
    vim.defer_fn(function()
      M.update_all_windows(false)
    end, 1)
    return
  end

  for _, curid in ipairs(api.nvim_list_wins()) do
    if utils.is_current_window(curid) then
      if configs.on_focus then
        configs.on_focus(curid)
      end

      if not configs.is_win_blur_disabled then
        view.focusWindow(curid)
      end
    else
      if configs.on_blur then
        configs.on_blur(curid)
      end
      if not configs.is_win_blur_disabled then
        view.blurWindow(curid)
      end
    end
  end
end

M.on_focus_lost = function()
  view.blurWindow(0)
end

M.on_focus_gained = function()
  view.focusWindow(0)
end

M.init = function(init_state)
  configs.nb_is_disabled = false
  configs.is_win_blur_disabled = _utils.get_default(init_state, false)
  M.setup_colors()
  fn['nebulous#autocmds']()
  M.update_all_windows()
end

M.disable = function()
  fn['nebulous#autocmds_remove']()
  for _, curid in ipairs(api.nvim_list_wins()) do
    view.focusWindow(curid)
    api.nvim_win_set_option(curid, 'cursorline', true)
  end
  configs.nb_is_disabled = true
  configs.is_win_blur_disabled = true
end

M.toggle = function()
  if configs.nb_is_disabled or configs.is_win_blur_disabled then
    M.init()
    print('[Nebulous] on')
  else
    M.disable()
    print('[Nebulous] off')
  end
end

M.disable_win_blur = function()
  for _, curid in ipairs(api.nvim_list_wins()) do
    view.focusWindow(curid)
  end
  configs.is_win_blur_disabled = true
end

M.toggle_win_blur = function()
  if configs.is_win_blur_disabled or configs.nb_is_disabled then
    M.init()
    print('[Nebulous] win blur on')
  else
    M.disable_win_blur()
    print('[Nebulous] win blur off')
  end
end

-- lua require("nebulous").disable_win_blur()
-- lua require("nebulous").toggle_win_blur()

M.setup = function(opts)
  local _con = require('nebulous.configs')
  opts = _utils.merge(_con.default, opts or {})
  configs = opts
  _con.updateConfigs(opts)

  M.init(opts.init_wb_with_disabled)
end

return M
