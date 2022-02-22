local M = {}
local _utils = require('hasan.utils')
local nb_is_disabled = true
local is_disable_win_blur = true
local nb_blur_hls = {
  'CursorLineNr:NebulousCursorLineNr',
  'Normal:Nebulous',
  'NormalNC:Nebulous',
}
local nb_blacklist_filetypes = {
  fzf = true,
  floating = true,
  qf = true,
  scratchpad = true,
}
-- local nb_pre_exist_hls = {
--   floaterm = {'Normal:Floaterm', 'NormalNC:FloatermNC' }
-- }

local utils = {
  win_has_blacklist_filetype = function(winid)
    local ft = vim.fn.getwinvar(winid, '&ft')
    return nb_blacklist_filetypes[ft]
  end,
  is_floting_window = function(winid)
    return vim.api.nvim_win_get_config(winid).relative ~= ''
  end,
  is_current_window = function(winid)
    return vim.api.nvim_get_current_win() == winid
  end
}

local focusWindow = function (winid)
  if utils.win_has_blacklist_filetype(winid) or utils.is_floting_window(winid)then
    return
  end
  vim.fn.setwinvar(winid, '&winhighlight', '')
end

local blurWindow = function(winid)
  if utils.win_has_blacklist_filetype(winid) or utils.is_floting_window(winid) then
    return
  end
  vim.fn.setwinvar(winid, '&winhighlight', table.concat(nb_blur_hls, ','))
end

M.setup_colors = function()
  vim.cmd[[
    hi Nebulous guibg=#323c4e
    hi NebulousCursorLineNr guifg=#4B5263
    hi EndOfBuffer guibg=NONE
  ]]
end

M.update_all_windows = function(shouldCheckFloat)
  if nb_is_disabled then
    return
  end

  -- check update windows again if there is a floating window
  if utils.is_floting_window(0) and shouldCheckFloat then
    vim.defer_fn(function ()
      M.update_all_windows(false)
    end, 1)
    return
  end

  for _,  curid in ipairs(vim.api.nvim_list_wins()) do
    if utils.is_current_window(curid) then
      vim.fn['nebulous#onWinEnter'](curid)
      if not is_disable_win_blur then
        focusWindow(curid)
      end
    else
      vim.api.nvim_win_set_option(curid, 'cursorline', false)
      if not is_disable_win_blur then
        blurWindow(curid)
      end
    end
  end
end

M.on_focus_lost = function ()
  blurWindow(0)
end

M.on_focus_gained = function ()
  focusWindow(0)
end

M.init = function (init_with_out_blur)
  nb_is_disabled = false
  is_disable_win_blur = _utils.get_default(init_with_out_blur, false)
  M.setup_colors()
  vim.fn['nebulous#autocmds']()
  M.update_all_windows()
end

M.disable = function ()
  vim.fn['nebulous#autocmds_remove']()
  for _,  curid in ipairs(vim.api.nvim_list_wins()) do
    focusWindow(curid)
    vim.api.nvim_win_set_option(curid, 'cursorline', true)
  end
  nb_is_disabled = true
  is_disable_win_blur = true
end

M.toggle = function ()
  if nb_is_disabled or is_disable_win_blur then
    M.init()
    print('[Nebulous] on')
  else
    M.disable()
    print('[Nebulous] off')
  end
end

M.disable_win_blur = function ()
  for _,  curid in ipairs(vim.api.nvim_list_wins()) do
    focusWindow(curid)
  end
  is_disable_win_blur = true
end

M.toggle_win_blur = function ()
  if is_disable_win_blur or nb_is_disabled then
    M.init()
    print('[Nebulous] win blur on')
  else
    M.disable_win_blur()
    print('[Nebulous] win blur off')
  end
end

-- lua require("nebulous").disable_win_blur()
-- lua require("nebulous").toggle_win_blur()
return M
