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

-- function lsp_config.tsserver_on_attach(client, bufnr)
--   -- lsp_config.common_on_attach(client, bufnr)
--   client.resolved_capabilities.document_formatting = false

--   local ts_utils = require "nvim-lsp-ts-utils"

--   -- defaults
--   ts_utils.setup {
--     debug = false,
--     disable_commands = false,
--     enable_import_on_completion = false,
--     import_all_timeout = 5000, -- ms

--     -- eslint
--     eslint_enable_code_actions = true,
--     eslint_enable_disable_comments = true,
--     eslint_bin = O.lang.tsserver.linter,
--     eslint_config_fallback = nil,
--     eslint_enable_diagnostics = true,

--     -- formatting
--     enable_formatting = O.lang.tsserver.autoformat,
--     formatter = O.lang.tsserver.formatter.exe,
--     formatter_config_fallback = nil,

--     -- parentheses completion
--     complete_parens = false,
--     signature_help_in_parens = false,

--     -- update imports on file move
--     update_imports_on_move = false,
--     require_confirmation_on_move = false,
--     watch_dir = nil,
--   }

--   -- required to fix code action ranges
--   ts_utils.setup_client(client)

--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", {silent = true})
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", {silent = true})
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", {silent = true})
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", {silent = true})
-- end

--[[ " autoformat
autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100) ]]
-- Java
-- autocmd FileType java nnoremap ca <Cmd>lua require('jdtls').code_action()<CR>

-- call matchadd("Conceal", '->' , 10, -1, {'conceal': '→'}
-- call matchadd("Conceal", '<=' , 10, -1, {'conceal': '≤'}
-- call search('\v<' . fern_previous_node . '>')

local reload_this_module = function ()
  -- local fname = vim.fn.fnamemodify(vim.fn.expand('%:p:r'), string.format(':gs?%s/??', vim.fn.getcwd()))
  -- local module_name = vim.fn.fnamemodify(fname, ':gs?\\?.?:gs?/?.?:gs?nvim.??:gs?lua.??:gs?.init??')

  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':gs?\\?.?:gs?/?.?')
  local module_name_from_root = vim.fn.fnamemodify(vim.fn.expand('%:p:r'), ':gs?\\?.?:gs?/?.?:gs?nvim.??:gs?lua.??:gs?.init??:gs?.lua??')
  local module_name = vim.fn.fnamemodify(module_name_from_root, ':gs?'..cwd..'.??')
  R(module_name, 'module reloaded')
end
