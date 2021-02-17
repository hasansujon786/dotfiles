" nnoremap <silent> - :Files <C-R>=expand('%:h')<CR><CR>
nnoremap <silent> <C-p>      :ProjectRecentFiles<CR>
nnoremap <silent> <C-k>p     :Files<CR>
nnoremap <silent> <C-k><C-p> :History<CR>

nnoremap <silent> <C-k>b :Buffers<CR>
nnoremap <silent> <C-k>w :Windows<CR>
nnoremap <silent> <C-k>m :Filetypes<CR>

nnoremap <silent> <C-k>' :Marks<CR>
nnoremap <silent> <C-k>? :GFile?<CR>
nnoremap <silent> <C-k>/ :History/<CR>
nnoremap <silent> <C-k>k :History:<CR>
nnoremap <silent> <C-k><C-k> :History:<CR>

nnoremap <A-/> :RG!<space>
xnoremap <A-/> "zy:RG! <C-r>z<CR>
nnoremap <silent> // :BLines<CR>

" Enhanced RipGrep integration with fzf
command! -nargs=* -bang RG call hasan#fzf#_ripgrep(<q-args>, <bang>0, '')
command! -nargs=1 -complete=dir RGDir call hasan#fzf#_ripgrep('', 1, <q-args>)
command! RGCurDir exe 'RGDir '.expand('%:h')
" Project recent & git filter togather
command! -bang ProjectRecentFiles call hasan#fzf#_project_recent_files(s:p(<bang>0), <bang>0)
command! -bang Projects call hasan#fzf#_projects(<bang>0)
command! FilesCurDir exe 'Files '.expand('%:h')
command! -bang Bookmarks call hasan#fzf#_bookmar(<bang>0)

" let g:fzf_layout = { 'down': '~70%' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
" let g:fzf_files_options = '--reverse --preview "(cat {})"'
" let g:fzf_preview_window = 'right:60%'

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \}

" Requires ripgrep
" let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
" let $FZF_DEFAULT_OPTS =' --color=dark,
"       \fg:-1,bg:-1,hl:#55B6C2,
"       \fg+:#E5C07B,bg+:#3E4452,hl+:#55B6C2,pointer:#E5C07B,
"       \info:#E06C75,prompt:#61AFEF,border:#5C6370,
"       \marker:#E06C75,spinner:#61afef,header:#5C6370,gutter:-1
"       \ --bind ctrl-a:select-all'

function! s:p(bang, ...)
  let preview_window = get(g:, 'fzf_preview_window', a:bang && &columns >= 80 || &columns >= 110 ? 'right': '')
  if len(preview_window)
    return call('fzf#vim#with_preview', add(copy(a:000), preview_window))
  endif
  return {}
endfunction

