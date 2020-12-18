function! s:custom_wrap(spec, fullscreen)
  " let colors = '--color=bg+:#3E4452,bg:#282C34,spinner:#C678DD,hl:#61AFEF,fg:#ABB2BF,prompt:#61AFEF,header:#5C6370,info:#E06C75,pointer:#E5C07B,marker:#E06C75,fg+:#E5C07B,gutter:#282C34,hl+:#61AFEF'
  let sp = "'"
  let win = a:fullscreen ? { 'window': '-tabnew' } : copy(get(g:, 'fzf_layout', {}))
  let opts = join(map(a:spec.options, 'sp . v:val . sp'))

  let global_action = copy(get(g:, 'fzf_action', {}))
  let action = copy(get(a:spec, 'action', global_action))
  if (len(keys(action)) > 0) | let opts = opts." --expect=".join(keys(action), ',') | endif

  return {
        \'_action': action,
        \'options': opts,
        \'sink*': a:spec['sink*'],
        \'source': a:spec.source,
        \keys(win)[0]: values(win)[0]}
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ProjectRecentFiles                                                      "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
  " recent_files =
  " 1. Sorted buffers list | filter: 'not term'
  " 2. oldfiles | filter: 'is readable', 'is inside cwd' & 'not in .git dir'
  " 3. git ls-files
  let recent_files = filter(map(fzf#vim#_buflisted_sorted(), 'bufname(v:val)'), 'len(v:val) && v:val !~ "term://" && v:val !~# ".git/"')
        \ + filter(copy(v:oldfiles), 'filereadable(fnamemodify(v:val, ":p")) && v:val =~ getcwd() && v:val !~# ".git/"')
        \ + split(system('git ls-files'), '')
  return fzf#vim#_uniq(map(filter([expand('%')], 'len(v:val)') + recent_files, 'fnamemodify(v:val, ":~:.")'))
endfunction

function! s:project_recent_files_sink(args)
  " if no line has selected
  if len(a:args) < 2 | return |endif
  " action: can be '', 'ctrl-t','ctrl-v' etc.
  let action = a:args[0]
  let lines = a:args[1:]

  if (action != '' && _#isFunc(g:fzf_action[action]))
    let Funcref = g:fzf_action[action]
    return Funcref(lines)

  elseif (action != '' && len(lines) == 1)
    let cmd = g:fzf_action[action]
    return execute(cmd.' '.lines[0])

  elseif (len(lines) > 1)
    let cmd = action == '' ? 'tab split' : g:fzf_action[action]
    let tab_nr = tabpagenr()

    for cur_line in lines
      execute(cmd.' '.cur_line)
    endfor

    if (action == '') | execute('tabclose '.tab_nr) | endif
    return
  end

  let line = a:args[1]
  let selectedBufNr = bufnr(line)
  let tabwin = [] " tabwin is the [n*tab,n*win] moves to the selected buf.
  for cur_tab in range(1, tabpagenr('$')) " range is 1 because tabpagenr count start from 1
    let buf_list_in_tab = tabpagebuflist(cur_tab)
    for cur_win in range(1, len(buf_list_in_tab))
      if selectedBufNr == buf_list_in_tab[cur_win-1]
        let tabwin = [cur_tab,cur_win] " if selectedBufNr is more than 1 it will give the last one
      endif
    endfor
  endfor

  if len(tabwin) > 0
    return s:jump(tabwin[0], tabwin[1])
  endif
  execute("edit ".line)
endfunction

function! s:jump(t, w)
  execute a:t.'tabnext'
  execute a:w.'wincmd w'
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Projects                                                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:projects_config_file = '~/.vim-projects'
let s:projects_action = {
      \ 'ctrl-e': function('s:edit_projects_config_file'),
      \}

function! hasan#fzf#_projects(bang) abort
  let options = ['--header-lines', !empty(fnamemodify(getcwd(), ':~')), '--prompt', 'Projects> ']

  call fzf#run(s:custom_wrap({
        \'options': options,
        \'action': s:projects_action,
        \'source': s:get_project_list(),
        \'sink*': function('s:projects_list_sink')},
        \ a:bang))
endfunction

function! s:projects_list_sink(args) abort
  " if no line has selected
  if len(a:args) < 2 | return |endif
  " action: can be '', 'ctrl-t','ctrl-v' etc.
  let action = a:args[0]
  let line = a:args[1]

  if (action != '' && _#isFunc(s:projects_action[action]))
    let Funcref = s:projects_action[action]
    return Funcref(line)
  endif

  execute('cd'.line)
  execute('edit '.line)
endfunction

function! s:get_project_list() abort
  let config_fname = expand(s:projects_config_file)
  let projects = readfile(config_fname)

  return [fnamemodify(getcwd(), ':~')] + projects
  " return fzf#vim#_uniq([fnamemodify(getcwd(), ':~')] + projects)
endfunction

function! s:edit_projects_config_file(...) abort
  execute('split '.s:projects_config_file)
endfunction
