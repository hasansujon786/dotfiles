" neovim default commands
" https://github.com/asvetliakov/vscode-neovim/tree/master/vim
" if exists('g:vscode') else " ordinary neovim endif

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-surround'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key-Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map leader (the dedicated user-mapping prefix key) to space
let mapleader="\<Space>"
let maplocalleader="\<Space>"

" Use q, qq & jk to return to normal mode
nnoremap <silent> q <ESC>:noh<CR>
vnoremap <silent> q <ESC>:noh<CR>
cnoremap qq <C-c>

nnoremap <silent> <leader>s :<C-u>call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap <silent> <leader>q :<C-u>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <silent> <leader>n :<C-u>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

" Commentary
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" nnoremap <silent> ? :<C-u>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>


