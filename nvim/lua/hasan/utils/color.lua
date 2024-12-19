local cmd = vim.cmd
local M = {}

M.toggle_bg_tranparent = function()
  local hl_normal = vim.g.onedark_theme_colors.dark_vivid.normal
  -- Transparent values
  local sed_cmd_val = '5s/false/true/'
  local highlights = {
    Normal = { bg = 'none', fg = hl_normal.fg },
  }

  if state.theme.bg_tranparent then
    -- Non-transparent values
    sed_cmd_val = '5s/true/false/'
    highlights = {
      Normal = { bg = hl_normal.bg, fg = hl_normal.fg },
    }
  end

  -- Update highlights
  for name, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, val)
  end

  -- Update sate file with sed
  local statePath = vim.fs.normalize(require('hasan.utils.file').config_root() .. '/lua/core/state.lua')
  state.theme.bg_tranparent = not state.theme.bg_tranparent
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
