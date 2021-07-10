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
