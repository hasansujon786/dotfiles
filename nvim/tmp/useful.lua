-- This is your alacritty.yml
-- 01 | # Window Customization
-- 02 | window:
-- 03 |   dimensions:
-- 04 |     columns: 100
-- 05 |     lines: 25
-- 06 |   padding:
-- 07 |     x: 20
-- 08 |     y: 20
-- 09 |   # decorations: none
-- 10 |   dynamic_title: true
-- 12 |   startup_mode: Windowed # Maximized Fullscreen
-- 13 | background_opacity: 0.92

-- function Sad(line_nr, from, to, fname)
--   vim.cmd(string.format("silent !sed -i '%ss/%s/%s/' %s", line_nr, from, to, fname))
-- end

-- function IncreasePadding()
--   foo('19', 0, 20, '~/dotfiles/alacritty/alacritty.windows.yml')
--   foo('20', 0, 20, '~/dotfiles/alacritty/alacritty.windows.yml')
-- end

-- function DecreasePadding()
--   Sad('19', 20, 0, '~/dotfiles/alacritty/alacritty.windows.yml')
--   Sad('20', 20, 0, '~/dotfiles/alacritty/alacritty.windows.yml')
-- end

-- vim.cmd[[
--   augroup ChangeAlacrittyPadding
--    au!
--    au VimEnter * lua DecreasePadding()
--    au VimLeavePre * lua IncreasePadding()
--   augroup END
-- ]]


Exemark = function()
  local bufnr = vim.fn.bufnr()
  local ns = vim.api.nvim_create_namespace("virttext_definition")
  local line = "Text"
  -- local line = "local line = lines[1]"
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_nr = cursor[1] - 2
  vim.api.nvim_win_set_cursor(0, cursor)
  vim.api.nvim_buf_set_extmark(
    bufnr,
    ns,
    line_nr,
    1,
  { virt_lines = { { { line, "NormalFloat" } } } }
    )
end

