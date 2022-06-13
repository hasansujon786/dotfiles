local ui = require('state').ui

P = function(...)
  vim.pretty_print(...)
  return ...
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

_G.feedkeys = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

_G.keymap = function(mode, lhs, rhs, opts)
  local def_opts = { silent = true, noremap = true }
  opts = vim.tbl_deep_extend('force', def_opts, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

_G.dap_adapter_path = vim.fn.stdpath('data') .. '/dap_adapters'

-- disabled_built_ins ==============================
local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  -- 'gzip',
  -- 'zip',
  -- 'zipPlugin',
  -- 'tar',
  -- 'tarPlugin',
  -- 'getscript',
  -- 'getscriptPlugin',
  -- 'vimball',
  -- 'vimballPlugin',
  -- '2html_plugin',
  -- 'logipat',
  -- 'rrhelper',
  -- 'spellfile_plugin',
  -- 'matchit'
}

vim.g.did_load_filetypes = 0
vim.g.do_filetype_lua = 1
for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end
-- Vsnip ==============================
-- vim.g.vsnip_namespace = ':'
vim.g.vsnip_snippet_dir = '~/dotfiles/nvim/.vsnip'
-- Sneak ==============================
vim.g['sneak#target_labels'] = ';wertyuopzbnmfLGKHWERTYUIQOPZBNMFJ0123456789'
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
-- vim-caser ==========================
vim.g.caser_prefix = '<leader>cs'
-- git-gutter =========================
vim.g.gitgutter_map_keys = 0
vim.g.gitgutter_sign_added = '▏'
vim.g.gitgutter_sign_modified = '▏'
vim.g.gitgutter_sign_removed = '▏'
vim.g.gitgutter_sign_removed_first_line = '▏'
vim.g.gitgutter_sign_removed_above_and_below = '▏'
vim.g.gitgutter_sign_modified_removed = '▏'
vim.g.gitgutter_floating_window_options = {
  relative = 'cursor',
  row = 1,
  col = 0,
  width = 10,
  height = vim.api.nvim_eval('&previewheight'),
  style = 'minimal',
  border = ui.border.style,
}
