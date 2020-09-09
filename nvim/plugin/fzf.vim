nnoremap <silent> - :Commands<CR>
" nnoremap <silent> - :Files <C-R>=expand('%:h')<CR><CR>
nnoremap <silent> <C-p> :History<CR>
nnoremap <silent> <C-k>p :Files<CR>
nnoremap <silent> <C-k><C-p> :GFile<CR>

nnoremap <silent> <C-k>w :Windows<CR>
nnoremap <silent> <C-k>m :Filetypes<CR>

nnoremap <silent> <C-k>? :GFile?<CR>
nnoremap <silent> <C-k>/ :History/<CR>
nnoremap <silent> <C-k>; :History:<CR>

nnoremap <silent> // :BLines<CR>
nnoremap <silent> ?? :Lines<CR>
nnoremap <A-/> :RG!<space>

let g:fzf_layout = { 'window': '30new' }
" let g:fzf_files_options = '--reverse --preview "(cat {})"'

let $FZF_DEFAULT_OPTS =' --color=dark,
      \fg:-1,bg:-1,hl:#55B6C2,
      \fg+:#E5C07B,bg+:-1,hl+:#55B6C2,pointer:#E5C07B,
      \info:#ABB2BF,prompt:#E06C75,
      \marker:#E06C75,spinner:#61afef,header:#c678dd,gutter:-1
      \ --bind ctrl-a:select-all'

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'q': 'normal <C-c>'}

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony','--reverse', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Shows Git history for the current buffer
command! FileHistory execute ":BCommits!"

" let g:fzf_colors =
" \ { 'fg':      ['fg', 'Normal'],
"   \ 'bg':      ['bg', 'Normal'],
"   \ 'hl':      ['fg', 'Comment'],
"   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"   \ 'hl+':     ['fg', 'Statement'],
"   \ 'info':    ['fg', 'Type'],
"   \ 'border':  ['fg', 'Ignore'],
"   \ 'prompt':  ['fg', 'Character'],
"   \ 'pointer': ['fg', 'Exception'],
"   \ 'marker':  ['fg', 'Keyword'],
"   \ 'spinner': ['fg', 'Label'],
"   \ 'header':  ['fg', 'Comment'] }
