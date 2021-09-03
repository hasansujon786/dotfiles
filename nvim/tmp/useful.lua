--  use lua function inside vimscript easily
-- let LuaModuleFunction = luaeval('require("mymodule").myfunction')
-- call LuaModuleFunction()

-- let LuaModuleFunction = luaeval('require"nvim-web-devicons".has_loaded()')
-- echo  LuaModuleFunction

-- https://nihilistkitten.me/nvim-lua-statusline/
local fn = vim.api.nvim_call_function
local cmd = vim.api.nvim_command

local function highlight(group, fg, bg)
  cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

highlight("StatusLeft", "red", "#32344a")
highlight("StatusMid", "green", "#32344a")
highlight("StatusRight", "white", "#32344a")

function _G.status_line()
  return table.concat {
    "%#StatusLeft#",
    "%f",
    "%=",
    "%#StatusMid#",
    "%l,",
    "%c",
    -- get_column_number(),
    "%=",
    "%#StatusRight#",
    "%p%%"
  }
end


cmd('set statusline='.."%!luaeval('status_line()')")
-- vim.o.statusline = "%!luaeval('status_line()')"

-- get list directory names
local opt_plug = vim.fn.globpath('C:\\Users\\hasan\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt', '*', 0, 1)

-- vsnip
-- return t "<C-n>"
-- local info = vim.fn.complete_info({'selected'})
-- if info.selected == -1 then
--   return t "<C-n><C-y><C-r>=luaeval('require\"compe\"._close()')<CR>"
-- else
--   return vim.fn["compe#confirm"]("<tab>")
-- end

-- creates a command
function command(cmd, nargs, attrs)
  attrs = attrs or '!'
  nargs = nargs or 0
  vim.cmd('command'..attrs..' -nargs='..nargs..' '..cmd)
end

-- local disabled_built_ins = {
--   'netrw',
--   'netrwPlugin',
--   'netrwSettings',
--   'netrwFileHandlers',
--   'gzip',
--   'zip',
--   'zipPlugin',
--   'tar',
--   'tarPlugin',
--   'getscript',
--   'getscriptPlugin',
--   'vimball',
--   'vimballPlugin',
--   '2html_plugin',
--   'logipat',
--   'rrhelper',
--   'spellfile_plugin',
--   'matchit'
-- }

-- for _, plugin in pairs(disabled_built_ins) do
--   vim.g["loaded_" .. plugin] = 1
-- end

-- Time
local timer = vim.loop.new_timer()
timer:start(2000, 0, function()
  print('foo')
end)

-- gets the current date/time according to pattern
local function date(pattern)
  pattern = pattern or "%Y-%m-%d_%X"
  return os.date(pattern, os.time())
end

-- Cursor
local function get_column_number()
  -- return fn.col(".")
  return fn('col', {'.'})
end

local function get_pos() return fn('getcurpos') end
-- set cursor position
local function set_pos(pos) fn('setpos', '.', pos) end

-- vim_item.kind = ({
--   Class = 'ﴯ',
--   Constant = '',
--   Color = '',
--   Constructor = '',
--   Enum = '',
--   EnumMember = '',
--   Event = '',
--   Field = 'ﰠ',
--   File = '',
--   Folder = '',
--   Function = '',
--   Interface = '',
--   Keyword = '',
--   Method = '',
--   Module = '',
--   Operator = '',
--   Property = 'ﰠ',
--   Reference = '',
--   Snippet = "",
--   Struct = 'פּ',
--   Text = '',
--   TypeParameter = '',
--   Unit = '塞',
--   Value = '',
--   Variable = ''
-- })[vim_item.kind]

-- symbols for autocomplete
-- vim.lsp.protocol.CompletionItemKind = {
--   "   (Text) ",
--   "   (Method)",
--   "   (Function)",
--   "   (Constructor)",
--   " ﴲ  (Field)",
--   "[] (Variable)",
--   "   (Class)",
--   " ﰮ  (Interface)",
--   "   (Module)",
--   " 襁 (Property)",
--   "   (Unit)",
--   "   (Value)",
--   " 練 (Enum)",
--   "   (Keyword)",
--   "   (Snippet)",
--   "   (Color)",
--   "   (File)",
--   "   (Reference)",
--   "   (Folder)",
--   "   (EnumMember)",
--   " ﲀ  (Constant)",
--   " ﳤ  (Struct)",
--   "   (Event)",
--   "   (Operator)",
--   "   (TypeParameter)",
-- }
