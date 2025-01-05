local cmd = vim.cmd
local M = {}

---Toggle background transparency
---@param auto_follow_state boolean
M.toggle_transparency = function(auto_follow_state)
  local theme = require('core.state').theme
  local is_transparent = not theme.transparency
  if auto_follow_state then
    is_transparent = theme.transparency
  end

  local hl_normal = vim.g.onedark_theme_colors.dark_vivid.normal

  local sed_cmd_val, highlights
  if is_transparent then
    -- Transparent values
    sed_cmd_val = '4s/false/true/'
    highlights = { Normal = { bg = 'none', fg = hl_normal.fg } }
  else
    -- Non-transparent values
    sed_cmd_val = '4s/true/false/'
    highlights = { Normal = { bg = hl_normal.bg, fg = hl_normal.fg } }
  end

  -- Update highlights
  for name, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, val)
  end

  -- Don't update state.lua
  if auto_follow_state then
    return
  end
  -- Update sate file with sed
  local statePath = vim.fs.normalize(require('hasan.utils.file').config_root() .. '/lua/core/state.lua')
  require('core.state').theme.transparency = is_transparent
  cmd(string.format("silent !sed -i '%s' %s", sed_cmd_val, statePath))
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

M.make_winhighlight = function(highlight)
  return table.concat(
    vim.tbl_map(function(key)
      return key .. ':' .. highlight[key]
    end, vim.tbl_keys(highlight)),
    ','
  )
end

return M
