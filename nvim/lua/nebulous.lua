local M = {}
local nb_is_disabled = false
local nb_blur_hls = {
  'CursorLineNr:NebulousCursorLineNr',
  'Normal:Nebulous',
  'NormalNC:Nebulous',
}
local nb_blacklist_filetypes = {
  fzf = true,
  floating = true,
  qf = true,
}
-- local nb_pre_exist_hls = {
--   floaterm = {'Normal:Floaterm', 'NormalNC:FloatermNC' }
-- }

local function init()
  vim.cmd[[
    hi Nebulous guibg=#363d49
    hi NebulousCursorLineNr guifg=#4B5263
  ]]

  -- resets
  vim.cmd[[
    hi EndOfBuffer guibg=NONE
    call nebulous#autocmds()
  ]]
end

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

M.updateAllWindows = function()
  if nb_is_disabled then
    return
  end

  for _,  curid in ipairs(vim.api.nvim_list_wins()) do
    if utils.is_current_window(curid) then
      focusWindow(curid)
    else
      blurWindow(curid)
    end
  end

  if utils.is_floting_window(0) then
    vim.defer_fn(function ()
      M.updateAllWindows()
    end, 10)
  end
end

M.on_focus_lost = function ()
  blurWindow(0)
end

M.on_focus_gained = function ()
  focusWindow(0)
end
M.setup = function ()
  init()
  M.updateAllWindows()
end

return M
