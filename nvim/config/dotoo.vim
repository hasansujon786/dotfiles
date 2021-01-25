au BufNewFile,BufRead *.org setf dotoo
hi dotoo_shade_stars ctermfg=NONE guifg='#282C34'
hi link dotoo_timestamp Comment
hi dotoo_deadline_scheduled guifg='#065F64'
let g:dotoo_todo_keyword_faces = [
  \ ['TODO', [':foreground 160,#E06C75', ':weight bold']],
  \ ['NEXT', [':foreground 27,#2563EB', ':weight bold']],
  \ ['WAITING', [':foreground 202,#D19A66', ':weight bold']],
  \ ['HOLD', [':foreground 53,#D19A66', ':weight bold']],
  \ ['MEETING', [':foreground 22,#E5C07B', ':weight bold']],
  \ ['PHONE', [':foreground 22,#C678DD', ':weight bold']],
  \ ['CANCELLED', [':foreground 22,#065F64', ':weight bold']],
  \ ['DONE', [':foreground 22,#10B981', ':weight bold']],
  \ ]

let g:dotoo#capture#refile = expand('~/Documents/org/refile.org')
let g:dotoo#agenda#files = [
  \ '~/Documents/org/*.org',
  \ '~/Documents/org/refile.org',
  \ '~/Documents/org/task.org'
  \ ]
let g:dotoo#capture#templates = {
  \ 't': {
  \   'description': 'Todo',
  \   'lines': [
  \     '** TODO %?',
  \     'DEADLINE: [%(strftime(g:dotoo#time#datetime_format))]'
  \   ],
  \  'target': g:dotoo#capture#refile
  \ },
  \}


fun! s:dotoo_capture()
  if expand('%:p') !=# ''
    let @f = printf('file:%s:%d', expand('%:p') , line('.'))
  endif
  call dotoo#capture#capture()
endf

nmap <nop> <Plug>(dotoo-capture)
nmap <silent> <Plug>(dotoo-capture-custom) :call <SID>dotoo_capture()<CR>
