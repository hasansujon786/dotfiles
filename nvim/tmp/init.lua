-- https://nihilistkitten.me/nvim-lua-statusline/
local fn = vim.api.nvim_call_function
local cmd = vim.api.nvim_command

local function highlight(group, fg, bg)
  cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

highlight("StatusLeft", "red", "#32344a")
highlight("StatusMid", "green", "#32344a")
highlight("StatusRight", "white", "#32344a")

local function get_column_number()
  -- return fn.col(".")
  return fn('col', {'.'})
end
-- print(get_column_number())
--
local function fileIcon()
  local icon, hl = require('nvim-web-devicons').get_icon('app.js', 'js', {default = true})
  return ico
end
fileIcon()

function status_line()
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
-- local opt_plug = vim.fn.globpath('C:\\Users\\hasan\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt', '*', 0, 1)
-- local start_plug = vim.fn.globpath('C:\\Users\\hasan\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start', '*', 0, 1)

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

function get_pos() return call('getcurpos') end

-- set cursor position
function set_pos(pos) call('setpos', '.', pos) end

-- gets the current date/time according to pattern
function date(pattern)
  pattern = pattern or "%Y-%m-%d_%X"
  return os.date(pattern, os.time())
end

-- checks if file exists
function is_file_exists(path)
  local f = io.open(path, 'r')
  if f ~= nil then io.close(f) return true else return false end
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

