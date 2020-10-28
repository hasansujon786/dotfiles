"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ProjectRecentFiles                                                      "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! hasan#fzf#_project_recent_files(preview, bang)
  let options = ['-m', '--header-lines', !empty(expand('%')), '--prompt', 'ProRecent> ']
  if has_key(a:preview, 'options')
    let options = l:options +  a:preview.options
  end
  call fzf#run(fzf#wrap({
        \ 'source': s:get_project_recent_files(),
        \ 'options': options},
        \ a:bang))
endfunction

function! s:get_project_recent_files()
  let files = filter(map(fzf#vim#_buflisted_sorted(), 'bufname(v:val)'), 'len(v:val)')
          \ + filter(filter(copy(v:oldfiles), 'v:val =~ getcwd()'), "filereadable(fnamemodify(v:val, ':p'))")
          \ + split(system('git ls-files'), '')
  return fzf#vim#_uniq(map(
    \ filter([expand('%')], 'len(v:val)')
    \   + filter(l:files, 'v:val !~ ".git/index" && v:val !~ "term://"'),
    \ 'fnamemodify(v:val, ":~:.")'))
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RG                                                                      "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! hasan#fzf#_ripgrep(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony','--reverse', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

