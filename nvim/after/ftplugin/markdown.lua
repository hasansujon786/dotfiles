local function follow_link(default_key)
  return function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return '<cmd>ObsidianFollowLink<CR>'
    else
      return default_key
    end
  end
end

vim.keymap.set('n', 'gf', follow_link('gf'), { noremap = false, expr = true })
vim.keymap.set('n', 'gd', follow_link('gd'), { noremap = false, expr = true })
