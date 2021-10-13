local M = {}
M.open_org_home = function (open)
  vim.cmd(open .. '~/vimwiki/home.org')
end

return M
