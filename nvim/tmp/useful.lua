local line = vim.fn.expand('<cfile>')
local _lines = vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() })
local selection = table.concat(vim.iter(_lines):map(vim.trim):totable())

local c = require('onedark.colors')
local util = require('onedark.util')
-- P(util.darken('#ca72e4', 0.2, c.bg0))

local ts_utils = require('nvim-treesitter.ts_utils')
ts_utils.get_node_text = vim.treesitter.query.get_node_text

local alt = vim.fn.bufnr('#')

vim.api.nvim_win_call(win, function()
  vim.opt.winhighlight:append({ Normal = 'DapUINormal', EndOfBuffer = 'DapUIEndOfBuffer' })
end)

jit.os:find('Windows')
local username = os.getenv('USERNAME') or os.getenv('USER') or os.getenv('LOGNAME')

local M = {}

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
load('user.settings')
load('user.keymaps')
load('user.commands')

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
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'TelescopePreviewerLoaded',
--   callback = function(args)
--     if args.data.filetype ~= 'help' then
--       vim.wo.number = true
--     elseif args.data.bufname:match('*.csv') then
--       vim.wo.wrap = false
--     end
--   end,
-- })

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

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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

-- local colors = require('omega.colors').get()
-- vim.api.nvim_set_hl(0, 'WinBarSeparator', { fg = colors.grey })
-- vim.api.nvim_set_hl(0, 'WinBarContent', { fg = colors.green, bg = colors.grey })

_G.winbar = function()
  if vim.api.nvim_eval_statusline('%f', {})['str'] == '[No Name]' then
    return ''
  end
  return '%#WinBarSeparator#'
    .. ''
    .. '%*'
    .. '%#WinBarContent#'
    .. '%f'
    .. '%*'
    .. '%#WinBarSeparator#'
    .. ''
    .. '%*'
end

-- vim.opt.winbar = "%{%v:lua.require'playground.winbar'.eval()%}"
-- vim.opt.winbar = "%{%winbar()%}"
-- vim.opt.winbar = "%{%winbar()%}"

-- local diagnostics_active = true
-- local toggle_diagnostics = function()
--   diagnostics_active = not diagnostics_active
--   if diagnostics_active then
--     vim.diagnostic.show()
--   else
--     vim.diagnostic.hide()
--   end
-- end

-- vim.keymap.set('n', '<leader>d', toggle_diagnostics)

-- local parent_dir = Path:new(finder.path):parent()

local function vertText()
  local bnr = vim.fn.bufnr('%')
  local ns_id = vim.api.nvim_create_namespace('demo')

  local line_num = 9
  local col_num = 5
  local opts = {
    end_line = 10,
    id = 1,
    virt_text = { { 'demo', 'IncSearch' } },
    virt_text_pos = 'right_align', -- overlay, eol, right_align
    virt_lines_leftcol = true,
    -- virt_text_hide = true,
    -- virt_text_win_col = 20,
    -- virt_lines = { { { '           demo line', 'NormalFloat' } } },
  }

  local mark_id = vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num - 1, col_num, opts) -- vim.api.nvim_buf_del_extmark(bnr, ns_id, id)
end
-- vertText()

local fn = vim.fn
local api = vim.api
local function get_outline_win()
  for i = 1, fn.tabpagewinnr(fn.tabpagenr(), '$') do
    local winid = fn.win_getid(i)
    local ft = vim.fn.getwinvar(winid, '&ft')
    if ft == 'Outline' then
      return winid, i
    end
  end
end

function Focus_with_outline(count)
  if count == 0 then
    feedkeys(':<up>')
    return
  end
  local winid = get_outline_win()

  if vim.fn.win_gotoid(winid) == 1 then
    api.nvim_win_set_cursor(winid, { count, 0 })
    feedkeys('<cr>')
  end
end
-- keymap('n', '<cr>', '<cmd>lua Focus_with_outline(vim.v.count)<cr>')

-- vim.o.foldcolumn = '1'
-- vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.statuscolumn = '%C%=%l%s'
-- vim.o.foldnestmax = 1

-- vim.o.statuscolumn = ' %=%@NumCb@%{v:relnum?v:relnum:v:lnum}%s'
-- vim.o.statuscolumn="%=%T%@NumCb@%r%@SignCb@%s%T"

---- https://www.reddit.com/r/neovim/comments/10fpqbp/gist_statuscolumn_separate_diagnostics_and/
--local M = {}
--_G.Status = M
-----@return {name:string, text:string, texthl:string}[]
--function M.get_signs()
--  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
--  return vim.tbl_map(function(sign)
--    return vim.fn.sign_getdefined(sign.name)[1]
--  end, vim.fn.sign_getplaced(buf, { group = '*', lnum = vim.v.lnum })[1].signs)
--end
--function M.column()
--  local sign, git_sign
--  for _, s in ipairs(M.get_signs()) do
--    if s.name:find('GitGutter') then
--      git_sign = s
--    else
--      sign = s
--    end
--  end

--  local components = {
--    sign and ('%#' .. sign.texthl .. '#' .. sign.text .. '%*') or '',
--    -- sign and ('%#' .. sign.texthl .. '#' .. icons[sign.name] .. '%*') or '',
--    [[%=]],
--    [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}]],
--    -- git_sign and ('%#' .. git_sign.texthl .. '#' .. git_sign.text .. '%*') or '  ',
--    git_sign and ('%#' .. git_sign.texthl .. '#' .. '▏' .. '%*') or ' ',
--  }
--  return table.concat(components, '')
--end

---- vim.opt.statuscolumn = [[%=%{v:relnum?v:relnum:v:lnum} ]]
---- vim.opt.statuscolumn = [[%!v:lua.Status.column()]]

-- {'samodostal/image.nvim'},
-- {'m00qek/baleia.nvim'},
-- require('image').setup {
-- render = {
--   min_padding = 5,
--   show_label = true,
--   use_dither = true,
--   foreground_color = true,
--   background_color = true
-- },
-- events = {
--   update_on_nvim_resize = true,
-- },
-- }

-- null_ls.register({
--   name = 'my-actions',
--   method = { null_ls.methods.CODE_ACTION },
--   filetypes = { '_all' },
--   generator = {
--     fn = function()
--       return {
--         {
--           title = 'add "hi mom"',
--           action = function()
--             local current_row = vim.api.nvim_win_get_cursor(0)[1]
--             vim.api.nvim_buf_set_lines(0, current_row, current_row, true, { 'hi mom' })
--           end,
--         },
--         {
--           title = 'add "hi mark"',
--           action = function()
--             local current_row = vim.api.nvim_win_get_cursor(0)[1]
--             vim.api.nvim_buf_set_lines(0, current_row, current_row, true, { 'hi mom' })
--           end,
--         },
--       }
--     end,
--   },
-- })

-- tbl_add_reverse_lookup = <function 794>,
-- tbl_contains = <function 795>,
-- tbl_count = <function 796>,
-- tbl_deep_extend = <function 797>,
-- tbl_extend = <function 798>,
-- tbl_filter = <function 799>,
-- tbl_flatten = <function 800>,
-- tbl_get = <function 801>,
-- tbl_isempty = <function 802>,
-- tbl_islist = <function 803>,
-- tbl_keys = <function 804>,
-- tbl_map = <function 805>,
-- tbl_values = <function 806>,

local function toggleQf()
  local ft = vim.bo.filetype
  if ft == 'qf' then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end

function _G.exec_user_autocmds(pattern)
  return vim.api.nvim_exec_autocmds('User', { pattern = pattern, modeline = false })
end
-- exec_user_autocmds('LightspeedEnter')

function _G.lsmarks()
  local buf = vim.api.nvim_create_buf(false, true)
  local marks_output = vim.fn.execute('marks')
  local lines = {}
  for line in marks_output:gmatch('[^\r\n]+') do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local current_win = vim.api.nvim_get_current_win()
  local current_width = vim.api.nvim_win_get_width(current_win)
  local current_height = vim.api.nvim_win_get_height(current_win)
  local opts = {
    relative = 'editor',
    width = 75,
    height = 20,
    row = math.floor((current_height - 20) / 2),
    col = math.floor((current_width - 75) / 2),
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  }
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(win, 'number', false)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', {})
end

-- Flutter Package to relative import
local function filter_package_to_relative_import(results)
  local action = vim.tbl_filter(function(item)
    return item.kind == 'refactor.convert.packageToRelativeImport'
  end, results[1].result)

  if action then
    return action[1]
  end
  return nil
end
function M.package_to_relative_importx(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local method = 'textDocument/codeAction'
  local options = {}
  local context = options.context or {}
  local params = vim.lsp.util.make_range_params()

  if not context.triggerKind then
    context.triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked
  end
  if not context.diagnostics then
    context.diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr)
  end
  params.context = context

  vim.lsp.buf_request_all(bufnr, method, params, function(results)
    local action = filter_package_to_relative_import(results)

    if action then
      vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')

      M.organize_imports_async(bufnr, function()
        vim.fn['repeat#set'](t('<Plug>FlutterPkgToRelative'))
      end)
    end
  end)
end

local up = [[]] -- in insert mode `<C-v><C-y>`
local down = [[]] -- in insert mode `<C-v><C-e>`
local target_win = vim.api.nvim_get_current_win() -- adapt this to the target winnr
Scroll_target_win = function(winnr, direction, count)
  vim.api.nvim_win_call(winnr, function()
    vim.cmd([[normal! ]] .. count .. direction)
  end)
end
Scroll_target_win(target_win, down, 10)

-- local init = function()
--   vim.notify = function(...)
--     if not require('lazy.core.config').plugins['nvim-notify']._.loaded then
--       require('lazy').load({ plugins = 'nvim-notify' })
--     end
--     require('notify')(...)
--   end
-- end
-- local initx = function()
--   vim.ui.select = function(...)
--     require('lazy').load({ plugins = { 'dressing.nvim' } })
--     return vim.ui.select(...)
--   end
--   vim.ui.input = function(...)
--     require('lazy').load({ plugins = { 'dressing.nvim' } })
--     return vim.ui.input(...)
--   end
-- end

-- testing
-- local start = vim.uv.hrtime()
-- vim.cmd('edit new.ts')
-- local cost = vim.uv.hrtime() - start
-- vim.print(cost / 1000000 .. 'ms')

-- Get the current window and cursor position
local win = vim.api.nvim_get_current_win()
local cursor_pos = vim.api.nvim_win_get_cursor(win)
-- cursor_pos is a table with two values: {row, col}
local cursor_row = cursor_pos[1]
local cursor_col = cursor_pos[2]
-- Get the window's top line and height
local top_line = vim.fn.line('w0')
local bottom_line = vim.fn.line('w$')
local window_height = vim.api.nvim_win_get_height(win)
-- Calculate relative cursor position within the visible window area
local relative_row = cursor_row - top_line + 1
local relative_col = cursor_col + 1 -- Neovim's column is zero-based, so add 1 to make it 1-based
print('Cursor position relative to viewable area:')
print('Row:', relative_row, 'Column:', relative_col)
print('Window height:', window_height)


-- ------------------------------------------------
-- -- highlight_word ------------------------------
-- ------------------------------------------------
-- local ns_id = vim.api.nvim_create_namespace('highlight_word')
-- local function highlight_current_word()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   row = row - 1 -- Convert to zero-based index

--   -- Get the line content
--   local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
--   if not line then
--     return
--   end

--   -- Match the word at cursor position
--   local word_start, word_end = line:find('%w+', col + 1)
--   if not word_start or not word_end then
--     return
--   end

--   -- Set highlight using extmark
--   vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1) -- Clear previous highlights
--   vim.api.nvim_buf_set_extmark(bufnr, ns_id, row, word_start - 1, {
--     end_col = word_end,
--     hl_group = 'Search', -- Change highlight group if needed
--   })
-- end
-- -- Run the function on CursorMoved event
-- vim.api.nvim_create_autocmd('CursorMoved', { callback = highlight_current_word })
