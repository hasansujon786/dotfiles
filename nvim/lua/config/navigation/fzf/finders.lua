local M = {}

function M.search_project_todos()
  local actions = require('fzf-lua.actions')

  local cmd = 'rg --line-number --column --color=always -g "!.git" -e "%s"'

  require('fzf-lua').fzf_exec(cmd:format(get_todo_pattern()), {
    prompt = 'Todos> ',
    actions = {
      ['default'] = actions.file_edit,
      ['alt-q'] = actions.file_sel_to_qf,
      ['ctrl-v'] = function(selected, o)
        -- list_files_from_branch_action('Gvsplit', selected, o)
      end,
    },
  })
end
-- vim.keymap.set('n', '<leader>pt', M.search_project_todos, { desc = 'Search TODOs with fzf-lua' })

local todo_keyfaces = require('core.state').project.todo_keyfaces
local function get_todo_pattern()
  return table.concat(todo_keyfaces, ':|') .. ':' -- Creates "TODO :|DONE :|INFO :|..."
end

function M.search_todos_to_quickfix()
  local cmd = 'rg --line-number --column --color=never -g "!.git" -e "%s"'
  local output = vim.fn.systemlist(cmd:format(get_todo_pattern()))

  -- Check if the command failed
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln('Error running rg: ' .. table.concat(output, '\n'))
    return
  end

  vim.fn.setqflist({}, 'r', { title = 'TODO Search', lines = output })

  vim.cmd.copen()
end

return M
