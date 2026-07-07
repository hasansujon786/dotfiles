local w = require('wezterm')
local M = {}

local repoes = os.getenv('REPOES') or w.home_dir .. '/repoes'

M.project_dirs = {
  repoes,
  -- srcPath .. '/work',
  -- srcPath .. '/other',
}

return M
