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

-- local autocmds = {
--   todo = {
--     {"BufEnter",     "*.todo",              "setl ft=todo"};
--     {"BufEnter",     "*meus/todo/todo.txt", "setl ft=todo"};
--     {"BufReadCmd",   "*meus/todo/todo.txt", [[silent call rclone#load("db:todo/todo.txt")]]};
--     {"BufWriteCmd",  "*meus/todo/todo.txt", [[silent call rclone#save("db:todo/todo.txt")]]};
--     {"FileReadCmd",  "*meus/todo/todo.txt", [[silent call rclone#load("db:todo/todo.txt")]]};
--     {"FileWriteCmd", "*meus/todo/todo.txt", [[silent call rclone#save("db:todo/todo.txt")]]};
--   };
--   vimrc = {
--     {"BufWritePost init.vim nested source $MYVIMRC"};
--     {"FileType man setlocal nonumber norelativenumber"};
--     {"BufEnter term://* setlocal nonumber norelativenumber"};
--   };
-- }
-- utils.create_augroups(autocmds)
--
-- table.insert(autocmds['doom_core'], {
--   {
--       'TextYankPost',
--       '*',
--       "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
--   },
-- })
-- augroup LuaHighLight
-- au!
-- au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}
-- augroup end

-- vsnip
-- return t "<C-n>"
-- local info = vim.fn.complete_info({'selected'})
-- if info.selected == -1 then
--   return t "<C-n><C-y><C-r>=luaeval('require\"compe\"._close()')<CR>"
-- else
--   return vim.fn["compe#confirm"]("<tab>")
-- end

