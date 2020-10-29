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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ProjectRecentFiles                                                      "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:custom_wrap(spec, fullscreen)
  let actions = copy(get(g:, 'fzf_action', {}))
  let colors = '--color=bg+:#3E4452,bg:#282C34,spinner:#C678DD,hl:#61AFEF,fg:#ABB2BF,prompt:#61AFEF,header:#5C6370,info:#E06C75,pointer:#E5C07B,marker:#E06C75,fg+:#E5C07B,gutter:#282C34,hl+:#61AFEF'
  let sp = "'"
  let opts = join(map(a:spec.options, 'sp . v:val . sp'))
  let w = a:fullscreen ? { 'window': '-tabnew' } : copy(get(g:, 'fzf_layout', {}))

  let custom =  {
        \'_action': actions,
        \'options': colors." ".opts." --expect=".join(keys(actions), ','),
        \'sink*': a:spec['sink*'],
        \'source': a:spec.source,
        \keys(w)[0]: values(w)[0]}
  return custom
endfunction

function! hasan#fzf#_project_recent_files(preview, bang)
  let options = ['-m', '--header-lines', !empty(expand('%')), '--prompt', 'ProRecent> ']
  if has_key(a:preview, 'options')
    let options = l:options + a:preview.options
  end

  call fzf#run(s:custom_wrap({
        \'options': options,
        \'source': s:get_project_recent_files(),
        \'sink*': function('s:project_recent_files_sink')},
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

function! s:project_recent_files_sink(args)
  let action = a:args[0]
  " An action can be on singel or multiple line
  let lines = a:args[1:]
  if action != ''
    let cmd = g:fzf_action[action]
    for i in lines
      execute(cmd." ".i)
    endfor
    return
  end

  let line = a:args[1]
  let selectedBufNr = bufnr(l:line)
  let tabwin = [] " tabwin is the [n*tab,n*win] moves to the selected buf.
  for t in range(1, tabpagenr('$')) " range is 1 because tabpagenr count start from 1
    let buffers = tabpagebuflist(t)
    for w in range(1, len(buffers))
      if selectedBufNr == buffers[w-1]
        let l:tabwin = [t,w] " if selectedBufNr is more than 1 it will give the last one
      endif
    endfor
  endfor

  if len(tabwin) > 0
    return s:jump(tabwin[0], tabwin[1])
  endif
  execute("edit ".l:line)
endfunction

function! s:jump(t, w)
  execute a:t.'tabnext'
  execute a:w.'wincmd w'
endfunction
