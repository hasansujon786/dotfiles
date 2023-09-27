local cmd = vim.cmd
local M = {}

M.toggle_bg_tranparent = function(followState)
  local normal = vim.g.onedark_theme_colors[vim.g.onedark_config.style].normal
  local stateValue = nil

  if state.theme.bg_tranparent and not followState or not state.theme.bg_tranparent and followState then
    -- remove transparent
    cmd(string.format('hi Normal guibg=%s guifg=%s', normal.bg, normal.fg))
    stateValue = '5s/true/false/'
  else
    -- make transparent
    cmd(string.format('hi Normal guibg=%s guifg=%s', 'None', normal.fg))
    stateValue = '5s/false/true/'
  end

  if not followState then
    local statePath = vim.fs.normalize(require('hasan.utils.file').config_root() .. '/lua/hasan/core/state.lua')
    state.theme.bg_tranparent = not state.theme.bg_tranparent
    cmd(string.format("silent !sed -i '%s' %s", stateValue, statePath))
  end
  require('hasan.utils.ui.palette').set_custom_highlights()
end

M.get_hl = function(name, opts)
  opts = opts or {}
  opts.name = name
  local ok, hl = pcall(vim.api.nvim_get_hl, opts.ns_id or 0, opts)
  if not ok then
    return
  end

  for _, key in pairs({ 'fg', 'bg', 'special' }) do
    if hl[key] then
      hl[key] = string.format('#%06x', hl[key])
    end
  end
  return hl
end

-- Define bg color
-- @param group Group
-- @param color Color
M.bg = function(group, col)
  cmd('hi ' .. group .. ' guibg=' .. col)
end

-- Define fg color
-- @param group Group
-- @param color Color
M.fg = function(group, col)
  cmd('hi ' .. group .. ' guifg=' .. col)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
M.fg_bg = function(group, fgcol, bgcol)
  cmd('hi ' .. group .. ' guifg=' .. fgcol .. ' guibg=' .. bgcol)
end

M.make_winhighlight = function(highlight)
  return table.concat(
    vim.tbl_map(function(key)
      return key .. ':' .. highlight[key]
    end, vim.tbl_keys(highlight)),
    ','
  )
end

return M
