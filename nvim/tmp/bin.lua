-- _G.nvimTreeEnter = function()
--   vim.cmd('highlight! Cursor blend=100')
--   vim.opt.guicursor = { 'n:Cursor/lCursor', 'v-c-sm:block', 'i-ci-ve:ver25', 'r-cr-o:hor2' }
--   P('foo')
-- end
-- _G.nvimTreeLeave = function()
--   vim.cmd('highlight! Cursor blend=NONE')
--   vim.opt.guicursor = { 'n-v-c-sm:block', 'i-ci-ve:ver25', 'r-cr-o:hor20' }
--   P('moo')
-- end
-- local function init(info)
--   nvimTreeEnter()
--   utils.augroup('NvimTreeCursor')(function(autocmd)
--     autocmd({ 'WinLeave', 'BufLeave' }, nvimTreeLeave, { buffer = info.buf })
--     autocmd('WinEnter', nvimTreeEnter, { buffer = info.buf })
--     -- autocmd('FileType', 'setlocal foldlevel=0', { pattern = 'vim' })
--   end)
-- end
-- autocmd('FileType', init, { pattern = 'NvimTree' })

-- change alacritty config on vim enter
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

-- local neoscroll = require('neoscroll')
-- neoscroll.setup()
-- local scroll_timer = vim.loop.new_timer()
-- local lines_to_scroll = 0
-- local cmd = vim.cmd
-- local function move_cursor_to_center(isCursorAboveCenter, def, callback)
--   lines_to_scroll = def
--   local function fooo()
--     if lines_to_scroll <= 0 then
--       scroll_timer:stop()
--       if callback ~= nil then
--         callback()
--       end
--       return
--     end
--     lines_to_scroll = lines_to_scroll - 1

--     if isCursorAboveCenter then
--       cmd([[norm! j]])
--     else
--       cmd([[norm! k]])
--     end
--   end

--   scroll_timer:start(1, 1, vim.schedule_wrap(fooo))
-- end
-- local function scroll_to(to)
--   neoscroll.scroll(to, true, 80, ease) -- default scroll
-- end

-- -- function Foo()
-- --   local isCursorAtCenter, isCursorAboveCenter, def = require('hasan.utils.ui.cursorline').cur_pos()
-- --   if not isCursorAtCenter then
-- --     moveCursonToCenter(isCursorAboveCenter, def)
-- --   end
-- -- end

-- keymap({ 'n', 'v' }, '<C-d>', function()
--   local cursor_at_center, cursor_at_top, differ, vp_lines = require('hasan.utils.ui.cursorline').cur_pos()

--   if vp_lines <= vim.wo.scroll then
--     scroll_to(vim.wo.scroll)
--     return
--   end

--   if not cursor_at_center and cursor_at_top then
--     move_cursor_to_center(cursor_at_top, differ, function() scroll_to(vim.wo.scroll - differ) end)
--     return
--   end

--   if not cursor_at_center and not cursor_at_top then
--     cmd([[norm! zz]])
--   end
--   scroll_to(vim.wo.scroll)
-- end)
-- keymap({ 'n', 'v' }, '<C-u>', function()
--   local cursor_at_center, cursor_at_top, differ, vp_lines = require('hasan.utils.ui.cursorline').cur_pos()

--   if vp_lines < vim.wo.scroll then
--     cmd([[norm! zz]])
--     scroll_to(-vim.wo.scroll)
--     return
--   end

--   if not cursor_at_center and not cursor_at_top then
--     move_cursor_to_center(cursor_at_top, differ, function()
--       cmd([[norm! zz]])
--       scroll_to(-(vim.wo.scroll - differ))
--     end)
--     return
--   end

--   if not cursor_at_center and cursor_at_top then
--     cmd([[norm! zz]])
--   end
--   scroll_to(-vim.wo.scroll)
-- end)
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     client.server_capabilities.semanticTokensProvider = nil
--   end,
-- })

-- local c = {
--   vim_mode = {
--     provider = {
--       name = 'vi_mode',
--       opts = { show_mode_name = true, padding = 'center' },
--     },
--     icon = '',
--     hl = hl_sections.main,
--     left_sep = { str = 'left_rounded', hl = hl_sections.main_sep },
--   },
--   separator = { provider = '' },
--   file_name = {
--     provider = {
--       name = 'file_info',
--       opts = {
--         type = 'relative-short',
--         file_modified_icon = '',
--         file_readonly_icon = '',
--         path_sep = '/',
--       },
--     },
--     hl = { bg = 'layer1', fg = 'muted1' },
--     left_sep = 'block',
--     right_sep = { separators.block, separators.right_rounded },
--   },
--   lsp_client_names = { provider = 'lsp_client_names', hl = hl_sections.muted_text, left_sep = ' ', right_sep = ' ' },
--   lsp_status = {
--     provider = function()
--       local progress_message = vim.lsp.util.get_progress_messages()
--       if #progress_message == 0 then
--         return get_lsp_client()
--       end

--       local status = {}
--       for _, msg in pairs(progress_message) do
--         table.insert(status, (msg.percentage or 0) .. '%% ' .. (msg.title or ''))
--       end
--       return table.concat(status, ' ')
--     end,
--     hl = hl_sections.muted_text,
--     left_sep = ' ',
--     right_sep = ' ',
--   },
--   harpoon = {
--     provider = function()
--       local ok, harpoon_mark = pcall(require, 'harpoon.mark')

--       if ok and harpoon_mark.status() ~= '' then
--         return ok and 'H:' .. harpoon_mark.status()
--       end
--       return ''
--     end,
--     hl = hl_sections.muted_text,
--     left_sep = ' ',
--     right_sep = ' ',
--   },
--   file_type = {
--     provider = { name = 'file_type', opts = { filetype_icon = true, case = 'titlecase' } },
--     hl = { fg = 'red', bg = 'darkblue', style = 'bold' },
--     left_sep = 'block',
--     right_sep = 'block',
--   },
--   file_encoding = {
--     provider = 'file_encoding',
--     hl = { fg = 'orange', bg = 'darkblue', style = 'italic' },
--     left_sep = 'block',
--     right_sep = 'block',
--   },
--   file_format = {
--     provider = 'file_format',
--     hl = { fg = 'orange', bg = 'darkblue', style = 'italic' },
--     left_sep = 'block',
--     right_sep = 'block',
--   },
--   line_percentage = {
--     provider = 'line_percentage',
--     hl = { bg = 'layer1', fg = 'muted1' },
--     right_sep = 'block',
--     left_sep = { separators.left_rounded, separators.block },
--   },
--   scroll_bar = {
--     provider = 'scroll_bar',
--     hl = { fg = 'yellow', bg = 'NONE' },
--   },
--   space_info = {
--     provider = "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}",
--     hl = hl_sections.muted_text,
--     left_sep = ' ',
--     right_sep = ' ',
--   },
--   location = {
--     provider = '%3l:%-2v',
--     hl = hl_sections.main,
--     left_sep = 'block',
--     right_sep = {
--       str = 'right_rounded',
--       hl = hl_sections.main_sep,
--     },
--   },
--   tabs = {
--     provider = function()
--       local last_tab_nr = vim.fn.tabpagenr('$')
--       if last_tab_nr == 1 then
--         return ''
--       end

--       local list = {}
--       local tab = { active = '', inactive = '' }
--       local cur_tab_nr = vim.fn.tabpagenr()

--       for i = 1, last_tab_nr do
--         if i == cur_tab_nr then
--           table.insert(list, withHl(tab.active, 'LualineTabActive'))
--         else
--           table.insert(list, withHl(tab.inactive, 'LualineTabInactive'))
--         end
--       end
--       return table.concat(list, ' ')
--     end,
--     left_sep = { str = ' ', hl = { bg = 'hiddenBg' } },
--     right_sep = { str = '▕', hl = { fg = '#2c3545', bg = 'hiddenBg' } },
--   },
--   diagnostic_errors = { provider = 'diagnostic_errors', hl = { fg = 'red' } },
--   diagnostic_warnings = { provider = 'diagnostic_warnings', hl = { fg = 'yellow' } },
--   diagnostic_hints = { provider = 'diagnostic_hints', hl = { fg = 'aqua' } },
--   diagnostic_info = { provider = 'diagnostic_info' },
-- }

-- -- Disable statusline in dashboard
-- vim.api.nvim_create_augroup('alpha_tabline', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'alpha_tabline',
--   pattern = 'alpha',
--   callback = function()
--     -- store current statusline value and use that
--     vim.wo.scrolloff = 0
--     local old_winbar = vim.opt.winbar
--     local old_laststatus = vim.opt.laststatus
--     local old_showtabline = vim.opt.showtabline
--     vim.api.nvim_create_autocmd('BufUnload', {
--       buffer = 0,
--       callback = function()
--         vim.opt.laststatus = old_laststatus
--         vim.opt.showtabline = old_showtabline
--         vim.opt.winbar = old_winbar
--       end,
--     })
--     vim.opt.laststatus = 0
--     vim.opt.showtabline = 0
--     vim.opt.winbar = ''
--   end,
-- })

-- Devicon highlight
-- local tail, path = telescopePickers.getPathAndTail(entry.filename)
-- local tailForDisplay = tail .. ' '
-- local icon, iconHighlight = telescopeUtilities.get_devicons(tail)

-- search in visible viewport
keymap('n', 'Z/', function()
  local scrolloff = vim.wo.scrolloff
  vim.wo.scrolloff = 0
  feedkeys('VHoLo0<Esc>/\\%V')

  vim.defer_fn(function()
    vim.wo.scrolloff = scrolloff
  end, 10)
end, { silent = false })

-- Function keys --------------------------------
keymap('n', '<F3>', ':set paste! paste?<CR>')

keymap('n', '<F7>', ':setlocal spell! spell?<CR>') -- Toggle spelling and show it's status
keymap('i', '<F7>', '<C-o>:setlocal spell! spell?<CR>')
keymap('n', '<F5>', '<Esc>:syntax sync fromstart<CR>')
keymap('i', '<F5>', '<C-o>:syntax sync fromstart<CR>')

-- lazy load plugin --------------------------------
-- https://www.reddit.com/r/neovim/comments/1ebcmj0/wip_lazy_loading_trio/
local function keymap_stub(mode, lhs, callback, opts)
  vim.keymap.set(mode, lhs, function()
    vim.keymap.del(mode, lhs)
    callback()
    vim.api.nvim_input(lhs) -- replay keybind
  end, opts)
end

local function command_stub(c, callback)
  vim.api.nvim_create_user_command(c, function()
    vim.api.nvim_del_user_command(c) -- remove stub command
    callback()
    cmd(c)
  end, {})
end

local function require_stub(mod, callback)
  package.preload[mod] = function()
    package.loaded[mod] = nil
    package.preload[mod] = nil
    return callback()
  end
end

-- { '<leader>tW', '<cmd>call autohl#_AutoHighlightToggle()<CR>', desc = 'Highlight same words' },
-- { '<leader>tb', '<cmd>lua require("hasan.utils.color").toggle_bg_tranparent(false)<CR>', desc = 'Toggle transparency' },
-- { '<leader>tL', '<cmd>lua require("hasan.utils.logger").toggle("cursorline")<CR>', desc = 'Toggle cursorline' },
-- { '<leader>tl', '<cmd>lua require("hasan.utils.logger").toggle("cursorcolumn")<CR>', desc = 'Toggle cursorcolumn' },
-- { '<leader>to', '<cmd>lua require("hasan.utils.logger").toggle("conceallevel", { 0, 2 })<CR>', desc = 'Toggle conceallevel' },
-- { '<leader>tc', '<cmd>lua require("hasan.utils.logger").toggle("concealcursor", { "nc", "" })<CR>', desc = 'Toggle concealcursor' },
-- { '<leader>ts', '<cmd>lua require("hasan.utils.logger").toggle("spell")<CR>', desc = 'Toggle spell' },
-- { '<leader>tw', '<cmd>lua require("hasan.utils.logger").toggle("wrap")<CR>', desc = 'Toggle wrap' },

-- snacks format
-- format = function(item, _)
--   local file = item.file
--   local ret = {}
--   local a = Snacks.picker.util.align
--   local icon, icon_hl = Snacks.util.icon(file.ft, 'directory')
--   ret[#ret + 1] = { a(icon, 3), icon_hl }
--   ret[#ret + 1] = { ' ' }
--   ret[#ret + 1] = { a(file, 20) }
--   return ret
-- end,
