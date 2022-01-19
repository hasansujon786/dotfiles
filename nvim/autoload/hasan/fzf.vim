" utils {{{
function! s:custom_wrap(spec, fullscreen)
  " let colors = '--color=bg+:#3E4452,bg:#282C34,spinner:#C678DD,hl:#61AFEF,fg:#ABB2BF,prompt:#61AFEF,header:#5C6370,info:#E06C75,pointer:#E5C07B,marker:#E06C75,fg+:#E5C07B,gutter:#282C34,hl+:#61AFEF'
  let sp = "'"
  let win = a:fullscreen ? { 'window': '-tabnew' } : copy(get(g:, 'fzf_layout', {}))
  let opts = a:spec.options

  let global_action = get(g:, 'fzf_action', {})
  let action = copy(get(a:spec, 'action', global_action))
  if (len(keys(action)) > 0)
    let opts = opts + ['--expect', join(keys(action), ',')]
  endif

  return {
        \'_action': action,
        \'options': opts,
        \'sink*': a:spec['sink*'],
        \'source': a:spec.source,
        \keys(win)[0]: values(win)[0]}
endfunction

function s:write_list(fpath, line, title, padding) abort
  let sp_nr = len(a:title) < a:padding ? a:padding - len(a:title) : 0
  let line = printf('%s %'.sp_nr.'s %s', a:title, '> ', a:line)
  call system('print "'.line.'" >> '.a:fpath)
endfunction

function! s:read_list(fpath, max) abort
  let projects = readfile(a:fpath, '', a:max)
  return fzf#vim#_uniq(projects)
endfunction
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RG {{{
function! hasan#fzf#_ripgrep(query, fullscreen, dir)
  let prompt = ['--prompt', 'RG> ']
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  if(a:dir != '')
    let l:path = a:dir == '.' ? expand('%:h') : a:dir
    let prompt = ['--prompt', 'RGDir> ', '--header', fnamemodify(l:path, ':~')]
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s '.l:path.' || true'
  endif

  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': prompt + ['--phony','--reverse', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ProjectRecentFiles {{{
function! hasan#fzf#_project_recent_files(preview, bang)
  let options = ['--header-lines', !empty(expand('%')), '--prompt', 'ProRecent> ']
  if has_key(a:preview, 'options')
    let options = l:options + a:preview.options
  end

  call fzf#run(s:custom_wrap({
        \'options': options,
        \'source': s:get_project_recent_files(),
        \'sink*': function('s:project_recent_files_sink')},
        \ a:bang))
endfunction

function s:oldfiles_filter() abort
  let default_filter = 'filereadable(fnamemodify(v:val, ":p")) && v:val =~ getcwd() && v:val !~# ".git/"'
  if !exists('g:fzf_project_files_filter_oldfiles')
    return default_filter
  endif

  let user_defined_filter = get(g:fzf_project_files_filter_oldfiles, fnamemodify(getcwd(), ':t'), '')
  return user_defined_filter == '' ? default_filter : default_filter.' && '.user_defined_filter
endfunction

function! s:get_project_recent_files()
  " recent_files =
  " 1. Sorted buffers list --> filter: 'not term'
  " 2. oldfiles --> filter: 'is readable', 'is inside cwd' & 'not in .git dir'
  " 3. git ls-files
  let recent_files = filter(map(fzf#vim#_buflisted_sorted(), 'bufname(v:val)'), 'len(v:val) && v:val !~ "term://"')
        \ + filter(copy(v:oldfiles), s:oldfiles_filter())
        \ + systemlist('git ls-files')
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
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Projects {{{
let g:fzf_projects_file = '~/.coc-project'

function! hasan#fzf#_projects(bang) abort
  let options = ['--header-lines', !empty(fnamemodify(getcwd(), ':~')), '--prompt', 'Projects> ']

  call fzf#run(s:custom_wrap({
        \'options': options,
        \'action': s:projects_action,
        \'sink*': function('s:projects_list_sink'),
        \'source': [fnamemodify(getcwd(), ':~')] + s:get_project_list(expand(g:fzf_projects_file), -1)},
        \ a:bang))
endfunction

function! s:get_project_list(fpath, max) abort
  let data = readfile(a:fpath, '', a:max)
  let list = keys(json_decode(data))
  return map(list, function('s:prettyfy_line'))
endfunction

function s:prettyfy_line(idx, val) abort
  let padding = 50
  let title = fnamemodify(a:val, ':t')
  let sp_nr = len(title) < padding ? padding - len(title) : 0
  let line = printf('%s %'.sp_nr.'s %s', title, '> ', fnamemodify(a:val, ':~'))
  return line
endfunction

function! s:projects_list_sink(args) abort
  " if no line has selected
  if len(a:args) < 2 | return |endif

  " action: can be '', 'ctrl-t','ctrl-v' etc.
  let action = a:args[0]
  if (action != '' && _#isFunc(s:projects_action[action]))
    let Funcref = s:projects_action[action]
    return Funcref(a:args)
  endif

  let line = split(a:args[1], '>  ')
  let path = line[1]
  execute('cd '.path)
  execute('edit '.path)
endfunction

function! s:open_coc_project(...) abort
  exe 'CocList project'
endfunction

function s:open_project_in_tmux_tab(line) abort
  if has_key(environ(), 'TMUX')
    let path = split(a:line[1], '>  ')[1]
    exe printf('silent !tmux new-window "cd %s && nvim %s"' ,path,path)
  else
    echoerr 'No tmux'
  endif
endfunction

let s:projects_action = {
      \ 'ctrl-x': function('s:open_coc_project'),
      \ 'ctrl-t': function('s:open_project_in_tmux_tab'),
      \}
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bookmarks {{{
let g:fzf_bookmarks_file = '~/.config/vim-bookmarks'

function! hasan#fzf#_bookmar(bang)
  call hasan#utils#_filereadable_and_create(g:fzf_bookmarks_file, v:true)
  let options = ['-m', '--prompt', 'Bookmarks> ']

  call fzf#run(s:custom_wrap({
        \'options': options,
        \'sink*': function('s:bookmark_sink'),
        \'source': s:read_list(expand(g:fzf_bookmarks_file), 15)},
        \ a:bang))
endfunction

function! s:bookmark_sink(args) abort
  let lines = [a:args[0]] + map(a:args[1:], 'split(v:val, ">  ")[1]')
  call s:project_recent_files_sink(lines)
endfunction

function! hasan#fzf#set_bookmark() abort
  let fname = expand('%:~')
  if(fname == '') | return _#echoError('No file name') | endif

  let default_name = fnamemodify(fname, ':t')
  let input = input('Set bookmark (default '.default_name.'): ') | redraw
  let bm_name = input == '' ? default_name : input

  call _#echoSuccess('New bookmark has written')
  call s:write_list(g:fzf_bookmarks_file, fname, bm_name, 50)
endfunction

function! hasan#fzf#edit_bookmark() abort
  execute('split '.g:fzf_bookmarks_file)
endfunction
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

