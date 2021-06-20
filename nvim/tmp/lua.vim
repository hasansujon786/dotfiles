
" equire'nvim-web-devicons'.get_icon(filename, extension, options)
" lua print(require'nvim-web-devicons'.has_loaded())

" lua type(print(require'nvim-web-devicons'.get_icon('.tmux.conf', 'conf')))

" lua print('Hello from Lua!')

" let scream = v:lua.string.rep('A', 10)
" echo scream
" 'AAAAAAAAAA'

" " How about a nice statusline?
" lua << EOF
" function _G.statusline()
"     local filepath = '%f'
"     local align_section = '%='
"     local percentage_through_file = '%p%%'
"     return string.format(
"         '%s%s%s',
"         filepath,
"         align_section,
"         percentage_through_file
"     )
" end
" EOF
" set statusline=%!v:lua.statusline()

" " Also works in expression mappings
" lua << EOF
" function _G.check_back_space()
"     local col = vim.api.nvim_win_get_cursor(0)[2]
"     return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
" end
" EOF

" inoremap <silent> <expr> <Tab>
"     \ pumvisible() ? "\<C-n>" :
"     \ v:lua.check_back_space() ? "\<Tab>" :
"     \ completion#trigger_completion()

" let g:foo = 1
" lua print(vim.g.foo)
" lua vim.api.nvim_set_option('smarttab', false)
" lua print(vim.o.smarttab)
" vim.api.nvim_get_var()

" lua vim.api.nvim_set_var('some_global_variable', { key1 = 'value', key2 = 300 })
" lua print(vim.inspect(vim.api.nvim_get_var('some_global_variable'))) -- { key1 = "value", key2 = 300 }
" vim.api.nvim_del_var('some_global_variable')

" lua print(vim.inspect(vim.api.nvim_get_var('foo')))

" lua vim.g.some_global_variable = 'hello'
" lua print(vim.inspect(vim.g.some_global_variable))
"


" lua print(vim.inspect(vim.api.nvim_get_var('foo')))
" lua print(vim.api.nvim_get_var('foo'))
" lua print(vim.api.nvim_call_function('expand', {'%'}))
" lua print(vim.api.nvim_call_function('fnamemodify', {
"   \ vim.api.nvim_call_function('expand', {'%'}),
"   \ ':e'
"   \ }))
" fnamemodify(expand('%'), ':t')

let g:foo = 'oooo'



" lua vim.api.nvim_set_var('g:foo', 'heee')
" lua vim.api.nvim_command('let g:foo = "oxx"')

" lua require"nvim-web-devicons".has_loaded()
" let LuaModuleFunction = luaeval('require("mymodule").myfunction')
" call LuaModuleFunction()

" let LuaModuleFunction = luaeval('require"nvim-web-devicons".has_loaded()')
" echo  LuaModuleFunction
"
" function! Load_icon(...) abort
" lua << EOF
"  local fname = vim.api.nvim_call_function('expand', {'%'})
"  local fextension = vim.api.nvim_call_function('fnamemodify', { fname, ':e' })
"  local icon = require'nvim-web-devicons'.get_icon(fname, fextension, { default = true })

"  -- workaround befor 0.5
"  -- vim.api.nvim_call_function('kissline#__set_icon_to_buffer', {icon})

" EOF
" endfunction
"
" -- f = {
" --   name = "+file", -- optional group name
" --   f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
" --   n = { "New File" }, -- just a label. don't create any mapping
" --   e = "Edit File", -- same as above
" --   ["1"] = "which_key_ignore",  -- special label to hide it in the popup
" --   b = { function() print("bar") end, "Foobar" }, -- you can also pass functions!
" --   s = { "<cmd>w<cr>", "Save file" }, -- create a binding with label
" -- },
