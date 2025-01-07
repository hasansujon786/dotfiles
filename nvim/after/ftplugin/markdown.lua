vim.wo.conceallevel = 2
vim.wo.concealcursor = 'nc'

-- local function follow_link(default_key)
--   return function()
--     if require('obsidian').util.cursor_on_markdown_link() then
--       return '<cmd>ObsidianFollowLink<CR>'
--     else
--       return default_key
--     end
--   end
-- end
-- local toggle_checkbox = function()
--   require('obsidian').util.toggle_checkbox()
-- end

-- keymap('n', 'gd', follow_link('gd'), { noremap = false, expr = true })
-- for _, action_key in ipairs({ 'cic', '<C-q>', '<C-space>', '<A-space>' }) do
--   keymap('n', action_key, toggle_checkbox)
-- end
