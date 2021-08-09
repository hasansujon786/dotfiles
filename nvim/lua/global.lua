-- Global functions
-- P = function(...)
--   local objects = vim.tbl_map(vim.inspect, {...})
--   print(unpack(objects))
-- end
P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  local plenary_reload = require('plenary.reload').reload_module


  R = function(name)
    plenary_reload(name)
    -- print(string.format('[%s] - module reloaded', name))
    return require(name)
  end
end


-- Sneak
vim.g['sneak#target_labels'] = ";wertyuopzbnmfLGKHWERTYUIQOPZBNMFJ0123456789"
vim.g['sneak#label'] = 1 -- use <tab> to jump through lebles
vim.g['sneak#use_ic_scs'] = 1 -- case insensitive sneak
vim.g['sneak#prompt'] = '  '
-- vim-visual-multi
vim.g.VM_leader = '<leader>vv'
vim.g.VM_theme_set_by_colorscheme = 0
-- emmet
vim.g.user_emmet_leader_key = '<C-c>'
