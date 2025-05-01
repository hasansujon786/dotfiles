" => ---------------------------------------------- {{{
" }}}
" neovim default commands https://github.com/asvetliakov/vscode-neovim/tree/master/vim
" if exists('g:vscode') else " ordinary neovim endif

" call plug#begin('~/.config/nvim/plugged')
" Plug 'michaeljsmith/vim-indent-object'
" Plug 'tpope/vim-surround'
" Plug 'asvetliakov/vim-easymotion'
" " Plug 'terryma/vim-multiple-cursors'
" " Plug 'unblevable/quick-scope'
" call plug#end()

" => Simple mappings ------------------------------- {{{

" Map leader
" let mapleader="\<Space>"
" let maplocalleader="\<Space>"
" Use q, qq & jk to return to normal mode
" nnoremap <silent> q <ESC>:noh<CR>
" vnoremap <silent> q <ESC>:noh<CR>
" Use Q to record macros
" nnoremap Q q
" j/k will move virtual lines (lines that wrap)
" Seamlessly treat visual lines as actual lines when moving around. => Todo
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" Store relative line number jumps in the jumplist if they exceed a threshold.
noremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
noremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'
" Toggle folds.
" nnoremap <tab> <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
" vnoremap <tab> <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
" zoom a vim pane
" nnoremap <silent> \ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
" nnoremap <silent> <Bar> :<C-u>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
" nnoremap <silent> ? :<C-u>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>

" }}}

" => Modify & Rearrange text ----------------------- {{{

" Make vaa select the entire file...
" vnoremap aa VGo1G
" select a block {} of code
nmap <silent> vaf /}<CR>V%
vmap <silent> vaf <Esc>/}<CR>V%
" map . in visual mode => Todo . cmd dose't work
" vnoremap . :norm.<cr>
" Keep selection when indenting/outdenting.
" vnoremap > >gv
" vnoremap < <gv
" Comment or uncomment lines using Commentary
" xmap gc  <Plug>VSCodeCommentary
" nmap gc  <Plug>VSCodeCommentary
" omap gc  <Plug>VSCodeCommentary
" nmap gcc <Plug>VSCodeCommentaryLine

" Move lines up and down in normal & visual mode => Todo (need to done in vscode)
" nnoremap <silent> <A-k> :move -2<CR>==
" nnoremap <silent> <A-j> :move +1<CR>==
" vnoremap <silent> <A-k> :move '<-2<CR>gv=gv
" vnoremap <silent> <A-j> :move '>+1<CR>gv=gv

" }}}

" => LSP ------------------------------------------- {{{

" nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
" nnoremap gR <Cmd>call VSCodeNotify('references-view.findReferences')<CR>
" nnoremap g. <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
" xnoremap g. <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>

" }}}

" => Leader commands ------------------------------- {{{

" Save & quit file Quickly
" nnoremap <silent> <leader>s :<C-u>call VSCodeNotify('workbench.action.files.save')<CR>
" nnoremap <silent> <leader>fs :<C-u>call VSCodeNotify('editor.action.formatDocument')<CR>
" " open Explorer
" nnoremap <silent> <leader>0 :<C-u>call VSCodeNotify('workbench.action.focusSideBar')<CR>
" nnoremap <silent> <leader>ob :<C-u>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
" nnoremap <silent> <leader>op :<C-u>call VSCodeNotify('workbench.view.explorer')<CR>
" " Toggle highlighting of current line and column
" nnoremap <silent> <leader>tl :setlocal cursorcolumn!<CR>
" " Git
" nnoremap <leader>g. :<C-u>call VSCodeNotify('git.stageAll')<CR>
" nnoremap <leader>gp :<C-u>call VSCodeNotify('editor.action.dirtydiff.next')<CR>
" nnoremap <leader>gr :<C-u>call VSCodeNotify('git.revertSelectedRanges')<CR>
" " Todo
" nnoremap <leader>gs :<C-u>call VSCodeNotify('git.stageSelectedRanges')<CR>
" nnoremap <leader>gu :<C-u>call VSCodeNotify('git.unstageSelectedRanges')<CR>


" " Toggle relative line numbers and regular line numbers.
" nnoremap <silent> <leader>mm :set nu! invrelativenumber<CR>
" nnoremap <silent> <leader>mu :set invrelativenumber<CR>
" " Switch between the last two files
" nnoremap <leader><tab> <c-^>

" }}}

" => Navigation ------------------------------------ {{{

" noremap <leader><leader> <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>

" " Jump between tabs
" nnoremap gl <Cmd>call VSCodeNotify('workbench.action.nextEditorInGroup')<CR>
" nnoremap gh <Cmd>call  VSCodeNotify('workbench.action.previousEditorInGroup')<CR>
" nnoremap gL <Cmd>call VSCodeNotify('workbench.action.lastEditorInGroup')<CR>
" nnoremap gH <Cmd>call VSCodeNotify('workbench.action.firstEditorInGroup')<CR>

" " window management
" nnoremap <leader>j <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
" nnoremap <leader>k <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
" nnoremap <leader>h <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
" nnoremap <leader>l <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
" nnoremap <leader>q <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
" nnoremap <leader>ws <Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>
" nnoremap <leader>wv <Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>
" nnoremap <leader>wo <Cmd>call VSCodeNotify('workbench.action.joinAllGroups')<CR>
" nnoremap <leader>ww <Cmd>call VSCodeNotify('workbench.action.focusNextGroup')<CR>
" nnoremap <leader>wW <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>

" nnoremap [c <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
" nnoremap ]c <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>

" nnoremap <C-j> <Cmd>call VSCodeNotify("workbench.action.navigateForward")<CR>
" }}}

" => Yank and copy --------------------------------- {{{

" " Prevent selecting and pasting from overwriting what you originally copied.
" vnoremap p pgvy
" " Keep cursor at the bottom of the visual selection after you yank it.
" vnoremap y ygv<Esc>
" " Ensure Y works similar to D,C.
" nnoremap Y y$
" " Prevent x from overriding the clipboard.
" noremap x "_x
" noremap X "_x
" Paste from current register/buffer in insert mode
imap <C-v> <C-R>*
cmap <C-v> <C-R>+
" " Easier system clipboard usage
" vnoremap <Leader>y "+ygv<Esc>
" vnoremap <Leader>d "+d
" nnoremap <Leader>p "+p
" nnoremap <Leader>P "+P
" vnoremap <Leader>p "+p
" vnoremap <Leader>P "+P

" }}}

" => Disabled-keys --------------------------------- {{{

" disable arrow keys in normal mode
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" }}}


" workaround for calling command picker in visual mode
xnoremap <C-P> <Cmd>call VSCodeNotifyVisual('workbench.action.quickOpen', 1)<CR>
xnoremap <C-S-P> <Cmd>call VSCodeNotifyVisual('workbench.action.showCommands', 1)<CR>
xnoremap <C-S-F> <Cmd>call VSCodeNotifyVisual('workbench.action.findInFiles', 0)<CR>
function! s:vscodeFormat(...) abort
  if !a:0
    let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
    return 'g@'
  elseif a:0 > 1
    let [line1, line2] = [a:1, a:2]
  else
    let [line1, line2] = [line("'["), line("']")]
  endif

  call VSCodeCallRange('editor.action.formatSelection', line1, line2, 0)
endfunction
call VSCodeExtensionNotify('visual-edit', b:multipleCursorsAppend, b:multipleCursorsVisualMode, line("'<"), line("'>"), col("'>"), b:multipleCursorsSkipEmpty)

" alt solution ===================================================================================
" { "key": "alt+a", "command": "vscode-neovim.send", "args": "<a-a>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+b", "command": "vscode-neovim.send", "args": "<a-b>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+c", "command": "vscode-neovim.send", "args": "<a-c>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+d", "command": "vscode-neovim.send", "args": "<a-d>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+e", "command": "vscode-neovim.send", "args": "<a-e>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+f", "command": "vscode-neovim.send", "args": "<a-f>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+g", "command": "vscode-neovim.send", "args": "<a-g>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+h", "command": "vscode-neovim.send", "args": "<a-h>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+i", "command": "vscode-neovim.send", "args": "<a-i>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+j", "command": "vscode-neovim.send", "args": "<a-j>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+k", "command": "vscode-neovim.send", "args": "<a-k>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+l", "command": "vscode-neovim.send", "args": "<a-l>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+m", "command": "vscode-neovim.send", "args": "<a-m>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+n", "command": "vscode-neovim.send", "args": "<a-n>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+o", "command": "vscode-neovim.send", "args": "<a-o>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+p", "command": "vscode-neovim.send", "args": "<a-p>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+q", "command": "vscode-neovim.send", "args": "<a-q>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+r", "command": "vscode-neovim.send", "args": "<a-r>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+s", "command": "vscode-neovim.send", "args": "<a-s>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+t", "command": "vscode-neovim.send", "args": "<a-t>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+u", "command": "vscode-neovim.send", "args": "<a-u>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+v", "command": "vscode-neovim.send", "args": "<a-v>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+w", "command": "vscode-neovim.send", "args": "<a-w>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+x", "command": "vscode-neovim.send", "args": "<a-x>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+y", "command": "vscode-neovim.send", "args": "<a-y>", "when": "editorTextFocus && neovim.init" },
" { "key": "alt+z", "command": "vscode-neovim.send", "args": "<a-z>", "when": "editorTextFocus && neovim.init" },
