-- sdfsdfsdfsdf sddfsdf
-- sdfsdfsdfsdf sddfsdf
-- first line ==========================================
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how middle
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how
-- hello how ----
-- hello how
-- hello how
-- last line hello how ==========================================
-- ==========================================

-- TODO: <01.11.22> add to keymap
local noSilent = { silent = false }
keymap('n', 'g/', function()
  local scrolloff = vim.wo.scrolloff
  vim.wo.scrolloff = 0

  feedkeys('VHoLo0<Esc>/\\%V')

  vim.defer_fn(function()
    vim.wo.scrolloff = scrolloff
  end, 10)
end, noSilent)
vim.cmd([[vnoremap / <ESC>/\%V]])

-- keymap('n', 'g/', 'VHoL<Esc>/\\%V', noSilent)
-- keymap('n', 'g/', '/\\%><C-r>=line("w0")-1<CR>l\\%<<C-r>=line("w$")+1<CR>l', { silent = false })
