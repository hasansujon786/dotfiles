local config = require('nebulous.configs')
local utils = require('nebulous.utils')

local fn = vim.fn
local api = vim.api
local view = {}

local function ignore_win(winid)
  return utils.win_has_blacklist_ft(winid) or utils.is_floating_win(winid) or utils.has_dynamically_deactive(winid)
end

view.focusWindow = function(winid)
  if ignore_win(winid) then
    return
  end

  fn.setwinvar(winid, '&winhighlight', '')
  pcall(vim.fn.matchdelete, winid, winid)
end

view.blurWindow = function(winid)
  if ignore_win(winid) then
    return
  end

  fn.setwinvar(winid, '&winhighlight', table.concat(config.options.nb_blur_hls, ','))
  pcall(fn.matchadd, 'Nebulous', '.', 200, winid, { window = winid })
end

view.update_all_windows = function(shouldCheckFloat)
  if config.options.nb_is_disabled then
    return
  end
  local focused_winid = api.nvim_get_current_win()
  local is_float_win = utils.is_floating_win(focused_winid)

  -- Skip from blur the alternate window
  if config.options.filter ~= nil and config.options.filter(focused_winid, is_float_win) then
    return
  end

  -- check update windows again if there is a floating window
  if is_float_win and shouldCheckFloat then
    vim.defer_fn(function()
      view.update_all_windows(false)
    end, 1)
    return
  end

  -- loop only for current tab's winnr
  for winnr = 1, fn.tabpagewinnr(fn.tabpagenr(), '$') do
    local cur_win_id = fn.win_getid(winnr)
    if utils.is_current_window(cur_win_id) then
      if config.options.on_focus then -- run custom user event function
        config.options.on_focus({ winid = cur_win_id, winnr = winnr })
      end

      if not config.options.is_win_blur_disabled then
        view.focusWindow(cur_win_id)
      end
    else
      if config.options.on_blur then -- run custom user event function
        config.options.on_blur({ winid = cur_win_id, winnr = winnr })
      end

      if not config.options.is_win_blur_disabled then
        view.blurWindow(cur_win_id)
      end
    end
  end
end

view.disable_win_blur = function()
  for _, curid in ipairs(api.nvim_list_wins()) do
    view.focusWindow(curid)
  end
  config.options.is_win_blur_disabled = true
end

view.disable = function()
  fn['nebulous#autocmds_remove']()
  for _, curid in ipairs(api.nvim_list_wins()) do
    view.focusWindow(curid)
    api.nvim_win_set_option(curid, 'cursorline', true)
  end
  config.options.nb_is_disabled = true
  config.options.is_win_blur_disabled = true
end

return view
