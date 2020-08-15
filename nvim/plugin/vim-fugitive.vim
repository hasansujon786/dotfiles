Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gbrowse', 'GV'] }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'tpope/vim-rhubarb', { 'on': 'Gbrowse' }      " git(hub) wrapper - open on GitHub
nmap <leader>gg :Gstatus<CR>
nmap gH :Gbrowse<CR>
