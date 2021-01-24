autocmd BufRead,BufNewFile *.dotoo set filetype=dotoo
autocmd BufRead,BufNewFile *.org   set filetype=dotoo
let g:dotoo#capture#refile = expand('~/Documents/org/refile.org')
let g:dotoo#agenda#files = [
                  \ '~/Documents/org/*.org',
                  \ '~/Documents/org/refile.org',
                  \ '~/Documents/org/task.org'
                  \ ]
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
