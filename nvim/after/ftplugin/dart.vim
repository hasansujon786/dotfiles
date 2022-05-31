setlocal commentstring=//\ %s

xnoremap <buffer> at abob
onoremap <buffer> at :normal vat<CR>
xnoremap <buffer> it iwl%o
onoremap <buffer> it :normal vit<CR>

noremap <buffer> <Leader>fc <Cmd>lua require('telescope').extensions.flutter.commands()<CR>
noremap <buffer> <Leader>fr <Cmd>FlutterRestart<CR>
" noremap <buffer> <Leader>fr <Cmd>lua require('project_run.utils').open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')<CR>

