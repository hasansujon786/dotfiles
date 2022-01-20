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


  R = function(moduleName, message)
    plenary_reload(moduleName)
    if message then
      print(string.format('[%s] - %s', moduleName, message))
    end
    return require(moduleName)
  end
end

-- netrw ==============================
vim.g.loaded_netrw  = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
-- Vsnip ==============================
-- vim.g.vsnip_namespace = ':'
vim.g.vsnip_snippet_dir = '~/dotfiles/nvim/.vsnip'
-- Sneak ==============================
vim.g['sneak#target_labels'] = ";wertyuopzbnmfLGKHWERTYUIQOPZBNMFJ0123456789"
vim.g['sneak#label'] = 1 -- use <tab> to jump through lebles
vim.g['sneak#use_ic_scs'] = 1 -- case insensitive sneak
vim.g['sneak#prompt'] = '  '
-- vim-visual-multi ===================
vim.g.VM_leader = '<leader>vv'
vim.g.VM_theme_set_by_colorscheme = 0
-- emmet ==============================
vim.g.user_emmet_leader_key = '<C-c>'
-- quick-scoope =======================
vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
-- vim-wiki ===========================
vim.g.vimwiki_list = {{path='~/vimwiki/', syntax='markdown', ext='.md', auto_toc=1}}
vim.g.vimwiki_folding = 'expr'
vim.g.vimwiki_markdown_link_ext = 1
vim.g.taskwiki_markup_syntax = 'markdown'
vim.g.vimwiki_key_mappings = {global = 0}
-- vim-caser ==========================
vim.g.caser_prefix = '<leader>cs'
-- git-gutter =========================
vim.g.gitgutter_map_keys = 0
vim.g.gitgutter_sign_added = '│'
vim.g.gitgutter_sign_modified = '│'
vim.g.gitgutter_sign_removed = '│'
vim.g.gitgutter_sign_removed_first_line = '│'
vim.g.gitgutter_sign_removed_above_and_below = '│'
vim.g.gitgutter_sign_modified_removed = '│'
