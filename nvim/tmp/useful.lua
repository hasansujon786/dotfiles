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

-- local pos = nvim.win_get_cursor(0)
-- local line = nvim.buf_get_lines(0, pos[1] - 1, pos[1], false)[1]
-- local _, start = line:find("^%s+")
-- nvim.win_set_cursor(0, {pos[1], start})


-- Telescope lsp_workspace_symbols query=profiles
-- Telescope lsp_dynamic_workspace_symbols

Edit_macro = function()
  local register = 'i'

  local opts = {default = vim.g.edit_macro_last or ''}

  if opts.default == '' then
    opts.prompt = 'Create Macro'
  else
    opts.prompt = 'Edit Macro'
  end

  vim.ui.input(opts, function(value)
    if value == nil then return end

    local macro = vim.fn.escape(value, '"')
    vim.cmd(string.format('let @%s="%s"', register, macro))

    vim.g.edit_macro_last = value
  end)
end

require("harpoon").setup({
  mark_branch = true,
  projects = {
    ["$HOME/Developer/your-project"] = {
      term = {
        cmds = {
          "docker exec -it web bash",
        }
      }
    }
  }
})


--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').find_files { previewer = false }
end)

local opts = { buffer = bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
vim.keymap.set('n', '<leader>wl', function()
  vim.inspect(vim.lsp.buf.list_workspace_folders())
end, opts)
vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)

local ts_utils = require("nvim-treesitter.ts_utils")
ts_utils.get_node_text = vim.treesitter.query.get_node_text
