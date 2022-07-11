local M = {}

local js = {
  comment = '\\/\\/ ',
  log = 'print(',
}
local filetype_options = {
  lua = {
    comment = '-- ',
    log = 'print(',
  },
  dart = {
    comment = '\\/\\/ ',
    log = 'print(',
  },
  javascript = js,
  typescript = js,
  javascriptreact = js,
  typescriptreact = js,
}

function M.delete_all_lines_with(what_to_delete)
  local opts = filetype_options[vim.bo.filetype]
  if not opts or not opts[what_to_delete] then
    return
  end

  vim.cmd('g/' .. opts[what_to_delete] .. '/d')
end

-- M.delete_all_lines_with('comment')
-- M.delete_all_lines_with('log')
-- require('hasan.utils.file').delete_all_lines_with('comment')
-- deleteAllComments()
-- deleteAllComments()
-- deleteAllComments()

return M


-- del lines            %s/\v(print).*/
-- insert end of lines  %s/\v(regex).*\zs/ \1
-- wrap all lines with quote %s/^\|$/'/g


-- :g/foo/d - Delete all lines containing the string “foo”. ...
-- :g!/foo/d - Delete all lines not containing the string “foo”.
-- :g/^#/d - Remove all comments from a Bash script. ...
-- :g/^$/d - Remove all blank lines. ...
-- :g/^\s*$/d - Remove all blank lines.
