local M = {}
M.open_org_home = function (open)
  local open_cmd = vim.bo.filetype == 'org' and 'edit' or open
  vim.cmd(open_cmd .. '~/vimwiki/home.org')
end

return M
