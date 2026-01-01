local w = require('wezterm')
local M = {}

M.bash_path = 'bash' --  'C:\\Program Files\\Git\\bin\\bash.exe'

local repoes = os.getenv('REPOES') or w.home_dir .. '/repoes'

M.project_dirs = {
  repoes,
  -- srcPath .. '/work',
  -- srcPath .. '/other',
}

return M
