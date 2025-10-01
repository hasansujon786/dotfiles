local M = {}

M.bash_path = 'bash' --  'C:\\Program Files\\Git\\bin\\bash.exe'

local repoes = os.getenv('REPOES') or os.getenv('HOME')

M.project_dirs = {
  repoes,
  -- srcPath .. '/work',
  -- srcPath .. '/other',
}

return M
