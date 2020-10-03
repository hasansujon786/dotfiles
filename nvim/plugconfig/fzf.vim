" nnoremap <silent> - :Commands<CR>
" nnoremap <silent> - :Files <C-R>=expand('%:h')<CR><CR>
nnoremap <silent> <C-p> :History<CR>
nnoremap <silent> <C-k>p :Files<CR>
nnoremap <silent> <C-k><C-p> :GFile<CR>

nnoremap <silent> <C-k>b :Buffers<CR>
nnoremap <silent> <C-k>w :Windows<CR>
nnoremap <silent> <C-k>m :Filetypes<CR>

nnoremap <silent> <C-k>? :GFile?<CR>
nnoremap <silent> <C-k>/ :History/<CR>
nnoremap <silent> <C-k>; :History:<CR>
nnoremap <silent> <C-k>' :Marks<CR>

nnoremap <A-/> :RG!<space>
vnoremap <A-/> y:RG!<space><C-r>"
nnoremap <silent> <C-k>l :Lines<CR>
nnoremap <silent> <C-k>k :BLines<CR>
nnoremap <silent> <C-k><C-k> :BLines<CR>

" Shows Git history for the current buffer
command! FileHistory execute ":BCommits!"

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony','--reverse', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

let g:fzf_layout = { 'down': '~50%' }
" let g:fzf_files_options = '--reverse --preview "(cat {})"'
" let g:fzf_preview_window = 'right:60%'
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'q': 'normal <C-c>',
      \}

let $FZF_DEFAULT_OPTS =
      \'--bind ctrl-a:select-all'

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Directory'],
  \ 'fg+':     ['fg', 'Type', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'Visual','CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Directory'],
  \ 'info':    ['fg', 'Keyword'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Directory'],
  \ 'gutter':  ['fg', 'Search'],
  \ 'pointer': ['fg', 'Type'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 guifg=#E5C07B guibg=#3B4048
  highlight fzf2 guifg=#98C379 guibg=#3B4048
  highlight fzf3 guifg=#ABB2BF guibg=#3B4048
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()
