" => Key-Mappings ------------------------------------- {{{

" Use q, qq & jk to return to normal mode
nnoremap <silent> q <ESC>:noh<CR>
vnoremap <silent> q <ESC>:noh<CR>
inoremap jk <ESC>
inoremap qq <ESC>
cnoremap qq <C-c>

" Use Q to record macros
nnoremap Q q

" [ The best remap ]
" j/k will move virtual lines (lines that wrap) and store
" relative line number jumps in the jumplist if they exceed a threshold.
noremap <silent> <expr> j (v:count == 0 ? 'gj' : v:count > 5 ? "m'" . v:count .'j' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : v:count > 5 ? "m'" . v:count .'k' : 'k')

" Vertical scrolling
nmap <silent> <A-d> <Plug>(SmoothieDownwards)
nmap <silent> <A-u> <Plug>(SmoothieUpwards)
nmap <silent> <A-f> <Plug>(SmoothieForwards)
nmap <silent> <A-b> <Plug>(SmoothieBackwards)
nmap <A-y> <C-y>
nmap <A-e> <C-e>
" Horizontal scroll
nmap <A-l> 5zl
nmap <A-h> 5zh

" Find & open file on current window
"map <C-p> :tabfind *

" => Copy-paset ===========================================
" Prevent selecting and pasting from overwriting what you originally copied.
vnoremap p pgvy
" Keep cursor at the bottom of the visual selection after you yank it.
vnoremap y ygv<Esc>
" Ensure Y works similar to D,C.
nnoremap Y y$
" Prevent x from overriding the clipboard.
noremap x "_x
noremap X "_x
" Paste from + register (system clipboard)
imap <C-v> <C-R>+
" Paste the last item from register
cmap <C-v> <C-R>"

" => Modify-&-Rearrange-texts =============================
" Make vaa select the entire file...
vnoremap aa VGo1G
" select a block {} of code
vnoremap <silent> ao <Esc>/}<CR>:noh<CR>V%
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
vnoremap <silent> <A-k> :move '<-2<CR>gv=gv
vnoremap <silent> <A-j> :move '>+1<CR>gv=gv

" => Moving-around-tabs-and-buffers =======================
" Resize splits
nnoremap <silent> <A-=> :resize +3<CR>
nnoremap <silent> <A--> :resize -3<CR>
nnoremap <silent> <A-.> :vertical resize +5<CR>
nnoremap <silent> <A-,> :vertical resize -5<CR>
" zoom a vim pane
nnoremap <silent> \ :wincmd _<cr>:wincmd \|<cr>:vertical resize -5<CR>
nnoremap <silent> <Bar> :wincmd =<cr>

" Jump between tabs
nnoremap <silent> gl :tabnext<CR>
nnoremap <silent> gh :tabprevious<CR>
nnoremap <silent> m<TAB> :tabmove+<CR>
nnoremap <silent> m<S-TAB> :tabmove-<CR>

" => Search-functionalities ===============================
" auto center on matched string
noremap n nzz
noremap N Nzz

" Pressing * or # searches for the current selection {{{
function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ack '" . l:pattern . "' " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
" }}}
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" vnoremap * "xy/<C-R>x<CR>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
" TODO: change binding
nnoremap <silent> C :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> C "sy:let @/=@s<CR>cgn

" => Insert-Mode-key-mapping ==============================
" Move cursor by character
inoremap <A-h> <left>
inoremap <A-l> <right>
inoremap <A-j> <down>
inoremap <A-k> <up>
" Move cursor by words
inoremap <A-f> <S-right>
inoremap <A-b> <S-left>
" Jump cursor to start & end of a line
inoremap <C-a> <C-O>^
inoremap <C-e> <C-O>$
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
" Delete by characters & words
inoremap <C-d> <Delete>
inoremap <A-d> <C-O>dw
inoremap <A-BS> <C-W>

" Make & move to a new line under the cursor
inoremap <silent> <A-CR> <C-o>o
" Make a new line under the cursor
inoremap <silent> <A-O> <Esc>mqA<CR><Esc>`qa
" Open html tags & place cursor to the middle
inoremap <silent> <A-o> <C-o>mq<CR><C-o>`q<CR>

" " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" " so that you can undo CTRL-U after inserting a line break.
inoremap <C-u> <C-G>u<C-U>

" => Terminal mappings ====================================
" Open terminal
nmap <silent> <C-t>s <C-w>s<C-w>j:terminal<CR>a
nmap <silent> <C-t>v <C-w>v<C-w>l:terminal<CR>a
" Silently open a shell in the directory of the current file
if has("win32") || has("win64")
 " map <C-t><C-t> :silent !start cmd /k cd %:p:h <CR>
  nmap <silent> <C-t><C-t> :tc %:h<CR>:silent !start bash<CR>:tc -<CR>
endif

" => Function key mappings ================================
" Toggle spelling and show it's status
nmap <F7> :setlocal spell! spell?<CR>
imap <F7> <Esc>:setlocal spell! spell?<CR>a
" TODO: need new bindings
nnoremap <leader>fw :normal! 1z=<CR>
nnoremap <leader>fp :normal! mz[s1z=`z<CR>
nnoremap <leader>fn :normal! mz]s1z=`z<CR>
" Spell commands
" Next wrong spell      ]s
" Previous wrong spell  [s
" Add to spell file     zg
" Prompt spell fixes    z=

" ToggleBackground {{{
fun! ToggleBackground()
  if (&background ==? 'dark')
    set background=light
  else
    set background=dark
  endif
endfun
" }}}
nnoremap <silent> <F10> :call ToggleBackground()<CR>

" }}}
" => Disabled-keys ------------------------------------ {{{
" disable arrow keys in normal mode
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vmap gs :sort<CR>

" }}}

