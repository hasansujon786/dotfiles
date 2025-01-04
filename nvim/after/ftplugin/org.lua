vim.o.conceallevel = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.tabstop = 2

local action = '<cmd>lua require("orgmode").action("org_mappings.toggle_checkbox")<CR>'
for _, action_key in ipairs({ 'cic', '<C-q>', '<C-space>', '<A-space>' }) do
  vim.keymap.set({ 'n', 'x' }, action_key, action, { desc = 'org toggle checkbox', buffer = true })
end

vim.keymap.set('n', 'g-', '<cmd>lua require("hasan.org").create_link()<CR>', { desc = 'Create Link', buffer = true })
vim.keymap.set('n', '-', '<Esc><cmd>lua require("hasan.org").create_link_visual()<CR>', { desc = 'Create Link', buffer = true })

vim.keymap.set('n', '<leader>v.', '<cmd>lua require("hasan.org.src_block").execute()<CR>', { desc = 'Execute SRC_BLOCK', buffer = true })
