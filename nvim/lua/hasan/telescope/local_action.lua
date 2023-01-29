-- Built-in actions
local transform_mod = require('telescope.actions.mt').transform_mod
local action_state = require('telescope.actions.state')

-- or create your custom action
local edit_buffer = function(prompt_bufnr, command)
  local entry = action_state.get_selected_entry()
  if entry == nil then
    return require('hasan.utils').Logger:warn('[telescope]: Nothing currently selected')
  end
  require('telescope.actions').close(prompt_bufnr)
  vim.cmd(string.format('%s %s', command, entry[1]))
end

local local_action = transform_mod({
  edit = function(prompt_bufnr)
    edit_buffer(prompt_bufnr, 'edit')
  end,
  vsplit = function(prompt_bufnr)
    edit_buffer(prompt_bufnr, 'vsplit')
  end,
  split = function(prompt_bufnr)
    edit_buffer(prompt_bufnr, 'split')
  end,
  tabedit = function(prompt_bufnr)
    edit_buffer(prompt_bufnr, 'tabedit')
  end,
  fedit = function(prompt_bufnr)
    edit_buffer(prompt_bufnr, 'Fedit')
  end,
  quicklook = function(_)
    local entry = action_state.get_selected_entry()
    if entry == nil then
      return require('hasan.utils').Logger:warn('[telescope]: Nothing currently selected')
    end

    require('hasan.utils.file').quickLook({ string.format('%s/%s', entry.cwd, entry[1]) })
  end,
})

return local_action
