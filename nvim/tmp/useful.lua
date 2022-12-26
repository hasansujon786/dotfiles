local c = require('onedark.colors')
local util = require('onedark.util')
P(util.darken('#ca72e4', 0.2, c.bg0))

local ts_utils = require('nvim-treesitter.ts_utils')
ts_utils.get_node_text = vim.treesitter.query.get_node_text

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
