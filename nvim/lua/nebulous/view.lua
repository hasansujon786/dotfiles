local config = require('nebulous.configs')
local utils = require('nebulous.utils')

local fn = vim.fn
local api = vim.api
local view = {}

view.focusWindow = function(winid)
  if utils.win_has_blacklist_filetype(winid) or utils.is_floting_window(winid) then
    return
  end
  vim.fn.setwinvar(winid, '&winhighlight', '')
  pcall(vim.fn.matchdelete, winid, winid)
end

view.blurWindow = function(winid)
  if utils.win_has_blacklist_filetype(winid) or utils.is_floting_window(winid) then
    return
  end
  vim.fn.setwinvar(winid, '&winhighlight', table.concat(config.options.nb_blur_hls, ','))
  pcall(fn.matchadd, 'Nebulous', '.', 200, winid, { window = winid })
end

return view
