" => Key-Mappings ------------------------------------- {{{

" Use q, qq & jk to return to normal mode
inoremap jk <ESC>
inoremap qq <ESC>
cnoremap qq <C-c>
if !exists('g:loaded_HLNext')
  nnoremap <silent> q <ESC>:nohlsearch<BAR>echo ''<CR>
  vnoremap <silent> q <ESC>:nohlsearch<CR>
else
  nnoremap <silent> q <ESC>:call HLNextOff()<BAR>:nohlsearch<BAR>echo ''<CR>
  vnoremap <silent> q <ESC>:call HLNextOff()<BAR>:nohlsearch<CR>
endif

" Exit file with confirm
nnoremap <silent> ZZ :Quit!<CR>

" Fold
nmap zm zM

" Goyo
nmap <silent> z<CR> :Goyo<CR>
vmap <silent> z<CR> :Goyo<CR>
nmap <silent> gz :Goyo<CR>
vmap <silent> gz :Goyo<CR>

" Switch between the alternate files
nnoremap <BS> <c-^>
" Use Q to record macros
noremap Q q
" Replay last used macro
" noremap <CR> @@

" Find & open file on current window
"nnoremap <C-p> :tabfind *

" => Copy-paste ===========================================
" Prevent selecting and pasting from overwriting what you originally copied.
vnoremap p pgvy
" Keep cursor at the bottom of the visual selection after you yank it.
vnoremap y ygv<Esc>
" Ensure Y works similar to D,C.
nnoremap Y y$
" Select the last yanked text
nnoremap gV `[v`]
" Prevent x from overriding the clipboard.
noremap x "_x
noremap X "_x
" Paste from + register (system clipboard)
inoremap <C-v> <C-R>+
cnoremap <C-v> <C-R>+
" Paste the last item from register
cnoremap <A-p> <C-R>"

" => Modify-&-Rearrange-texts =============================
" increase selected numbers
xnoremap + g<C-a>
xnoremap - g<C-x>
" Print the number of occurrences of the current word under the cursor
vmap <C-g> *<C-O>:%s///gn<CR>
" Make vaa select the entire file...
vnoremap aa VGo1G
" a fix to select end of line
vnoremap $ $h
" select a block {} of code
vnoremap ao <ESC>va{%V%
nnoremap yao va{%V%y
nnoremap dao va{%V%d
" map . in visual mode
vnoremap . :norm.<cr>
" Keep selection when indenting/outdenting.
vnoremap > >gv
vnoremap < <gv

" Comment or uncomment lines
nmap <C-_> mz_gcc`z
imap <C-_> <ESC>_gccgi
vmap <C-_> _gcgv

" Move lines up and down in normal & visual mode
nnoremap <silent> <A-j> :move +1<CR>==
nnoremap <silent> <A-k> :move -2<CR>==
xnoremap <silent> <A-k> :call hasan#utils#visual_move_up()<CR>
xnoremap <silent> <A-j> :call hasan#utils#visual_move_down()<CR>
" vnoremap <silent> <A-k> :move '<-2<CR>gv=gv
" vnoremap <silent> <A-j> :move '>+1<CR>gv=gv

 " exchange_operator.vim
vmap gx <Plug>(exchange-operator)
nmap gx <Plug>(exchange-operator)

" => Navigate =============================================
" jump in file
nnoremap <silent> H H:exec 'norm! '. &scrolloff . 'k'<cr>
nnoremap <silent> L L:exec 'norm! '. &scrolloff . 'j'<cr>
" Character-wise jumps always
nnoremap '   `
vnoremap '   `
nnoremap ''  `'
vnoremap ''  `'

" Vertical scrolling
nmap <silent> <A-d> <C-d>
nmap <silent> <A-u> <C-u>
nmap <silent> <A-f> <C-f>
nmap <silent> <A-b> <C-b>
nmap <A-y> <C-y>
nmap <A-e> <C-e>
" Horizontal scroll
nmap <A-l> 5zl
nmap <A-h> 5zh

" Resize splits
nnoremap <silent> <A-=> :resize +3<CR>
nnoremap <silent> <A--> :resize -3<CR>
nnoremap <silent> <A-.> :vertical resize +5<CR>
nnoremap <silent> <A-,> :vertical resize -5<CR>
" zoom a vim pane
nnoremap <silent> \ :call hasan#utils#MaximizesWinToggle()<CR>
nnoremap <silent> <Bar> :wincmd =<cr>

nnoremap <C-j> <C-i>
" Jump between tabs
nmap <tab> gt
nmap <s-tab> gT
vmap <tab> gt
vmap <s-tab> gT
" Move tabs
nnoremap <silent> ]<TAB> :tabmove+<CR>
nnoremap <silent> [<TAB> :tabmove-<CR>

" Quickfix list
nmap ]q :cnext<CR>
nmap [q :cprev<CR>
nmap ]Q :clast<CR>
nmap [Q :cfirst<CR>

" => Search-functionalities ===============================
" highlight current word in file
nnoremap z/ :call autohl#_AutoHighlightToggle()<CR>

" auto center on matched string
xnoremap / y/<C-R>"<CR>

" Pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call hasan#utils#visualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call hasan#utils#visualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" vnoremap * "xy/<C-R>x<CR>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> c* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> C "sy:let @/=@s<CR>cgn
" delete matches
nmap dm :%s/<c-r>///g<CR>
" change matches
nmap cm :%s/<c-r>///g<Left><Left>

" => Insert-Mode-key-mapping ==============================
" Move cursor by character
inoremap <A-h> <left>
inoremap <A-l> <right>
inoremap <A-j> <down>
inoremap <A-k> <up>
" Move cursor by words
inoremap <A-f> <S-right>
inoremap <A-b> <S-left>
cnoremap <A-b> <S-Left>
cnoremap <A-f> <S-Right>
" Jump cursor to start & end of a line
inoremap <C-a> <C-o>^<C-g>u
inoremap <expr> <C-e> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
" Delete by characters & words
inoremap <C-d> <Delete>
inoremap <A-d> <C-O>dw
inoremap <A-BS> <C-W>
cnoremap <C-d> <Delete>
cnoremap <A-d> <S-Right><C-W><Delete>
cnoremap <A-BS> <C-W>

" Make & move to a new line under the cursor
inoremap <silent> <A-CR> <C-o>o
" Make a new line under the cursor
inoremap <silent> <A-O> <Esc>mqA<CR><Esc>`qa
" Open HTML tags & place cursor to the middle
inoremap <silent> <A-o> <C-o>mq<CR><C-o>`q<CR>

" " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" " so that you can undo CTRL-U after inserting a line break.
inoremap <C-u> <C-G>u<C-U>

" => Terminal mappings ====================================
" Open terminal
" nnoremap <silent> <leader>ts <C-w>s<C-w>J:terminal<CR>
" nnoremap <silent> <leader>tv <C-w>v<C-w>L:terminal<CR>
" Silently open a shell in the directory of the current file
if has("win32") || has("win64")
 " nnoremap <C-t><C-t> :silent !start cmd /k cd %:p:h <CR>
  nnoremap <silent> <C-t><C-t> :tc %:h<CR>:silent !start bash<CR>:tc -<CR>
endif
tmap <C-o> <C-\><C-n>

" => Function key mappings ================================
nnoremap <silent> <F3> :set paste!<CR>
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" Toggle spelling and show it's status
nnoremap <F7> :setlocal spell! spell?<CR>
inoremap <F7> <Esc>:setlocal spell! spell?<CR>a
nmap <silent><Plug>FixCurrentWord 1z=:call repeat#set("\<Plug>FixCurrentWord")<CR>
" Spell commands
" Next wrong spell      ]s
" Previous wrong spell  [s
" Add to spell file     zg
" Prompt spell fixes    z=

" }}}
" => Disabled-keys ------------------------------------ {{{
" disable arrow keys in normal mode
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Bindings for more efficient path-based file navigation
" nnoremap ,f :find *
" nnoremap ,v :vert sfind *
" nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
" nnoremap ,V :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>

" vmap gs :sort<CR>

" nnoremap S :%s//gI<Left><Left><Left>
" nnoremap <silent> <F10> :call Utils_ToggleBackground()<CR>

" CTRL-L to fix syntax highlight
" nnoremap <silent><expr> <C-l> empty(get(b:, 'current_syntax'))
"       \ ? "\<C-l>"
"       \ : "\<C-l>:syntax sync fromstart\<CR>"
"
" }}}

