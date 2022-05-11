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

local async = require('plenary.async')
local packer_sync = function()
  async.run(function()
    vim.notify.async('Syncing packer.', 'info', {
      title = 'Packer',
    })
  end)
  local snap_shot_time = os.date('!%Y-%m-%dT%TZ')
  vim.cmd('PackerSnapshot ' .. snap_shot_time)
  vim.cmd('PackerSync')
end

keymap('n', '<leader>ps', '', {
  callback = packer_sync,
})

local load = function(mod)
  package.loaded[mod] = nil
  return require(mod)
end
load 'user.settings'
load 'user.keymaps'
load 'user.commands'

Exemark = function()
  local bufnr = vim.fn.bufnr()
  local ns = vim.api.nvim_create_namespace('virttext_definition')
  local line = 'Text'
  -- local line = "local line = lines[1]"
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_nr = cursor[1] - 2
  vim.api.nvim_win_set_cursor(0, cursor)
  vim.api.nvim_buf_set_extmark(bufnr, ns, line_nr, 1, { virt_lines = { { { line, 'NormalFloat' } } } })
end

-- local pos = nvim.win_get_cursor(0)
-- local line = nvim.buf_get_lines(0, pos[1] - 1, pos[1], false)[1]
-- local _, start = line:find("^%s+")
-- nvim.win_set_cursor(0, {pos[1], start})

-- Telescope lsp_workspace_symbols query=profiles
-- Telescope lsp_dynamic_workspace_symbols

Edit_macro = function()
  local register = 'i'

  local opts = { default = vim.g.edit_macro_last or '' }

  if opts.default == '' then
    opts.prompt = 'Create Macro'
  else
    opts.prompt = 'Edit Macro'
  end

  vim.ui.input(opts, function(value)
    if value == nil then
      return
    end

    local macro = vim.fn.escape(value, '"')
    vim.cmd(string.format('let @%s="%s"', register, macro))

    vim.g.edit_macro_last = value
  end)
end

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').find_files({ previewer = false })
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

local ts_utils = require('nvim-treesitter.ts_utils')
ts_utils.get_node_text = vim.treesitter.query.get_node_text

vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})

-- set_lines({lines}, {A}, {B}, {new_lines})           *vim.lsp.util.set_lines()*
-- vim.lsp.util.open_floating_preview()

--   local autocmd = [[ do User LspAttachBuffers ]]
--   vim.cmd(autocmd)

-- M.get_selection = function()
--   -- interface to call vim functions
--   local f = vim.fn

--   -- Save register `s`. Just in case.
--   local temp = f.getreg('s')

--   -- Put current selection to register `s`
--   vim.cmd('normal! gv"sy')

--   -- Put register `s` in the "search register". Escape newlines and slash
--   f.setreg('/', f.escape(f.getreg('s'), '/'):gsub('\n', '\\n'))

--   -- Restore register `s`
--   f.setreg('s', temp)
-- end

-- M.trailspace_trim = function()
--   -- Save cursor position to later restore
--   local curpos = vim.api.nvim_win_get_cursor(0)

--   -- Search and replace trailing whitespace
--   vim.cmd([[keeppatterns %s/\s\+$//e]])
--   vim.api.nvim_win_set_cursor(0, curpos)
-- end

-- M.file_explorer = function(cwd)
--   if vim.o.lines > 17 then
--     -- Open file explorer in floating window
--     require('lir.float').toggle(cwd)
--   else
--     -- take the whole window
--     vim.cmd('edit ' .. (cwd or vim.fn.expand('%:p:h')))
--   end
-- end

-- local function theme_change_timeday(start_hour, end_hour)
--   local time = tonumber(vim.fn.strftime('%H'))
--   if time < start_hour or time > end_hour then
--     vim.cmd([[colorscheme onedark]])
--   else
--     vim.cmd([[colorscheme blue]])
--   end
--   vim.cmd([[doautoall ColorScheme]])
-- end
-- vim.api.nvim_create_autocmd('VimEnter', { --FocusGained
--   pattern = '*',
--   callback = function()
--     theme_change_timeday(9, 15)
--   end,
--   group = init_group,
--   -- nested = true, -- dow notwork in this case
-- })
