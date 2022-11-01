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
-- hello how
-- TODO: <01.11.22> add to keymap
local noSilent = { silent = false }
keymap('n', 'z/', '/\\%><C-r>=line("w0")-1<CR>l\\%<<C-r>=line("w$")+1<CR>l', { silent = false })
keymap({ 'n', 'v' }, 'g/', '<ESC>/\\%V', noSilent)
keymap('n', 'z/', function()
  local scrolloff = vim.wo.scrolloff
  vim.wo.scrolloff = 0
  feedkeys('VHoLo0<Esc>/\\%V')

  vim.defer_fn(function()
    vim.wo.scrolloff = scrolloff
  end, 10)
end, noSilent)
