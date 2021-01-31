iabbrev <expr> <buffer> <silent> deadline: 'DEADLINE: ['.strftime(g:dotoo#time#date_day_format).']'
iabbrev <expr> <buffer> <silent> scheduled: 'SCHEDULED: ['.strftime(g:dotoo#time#date_day_format).']'
iabbrev <expr> <buffer> <silent> closed: 'CLOSED: ['.strftime(g:dotoo#time#date_day_format).']'
iabbrev <expr> <buffer> <silent> date: '['.strftime(g:dotoo#time#date_day_format).']'
iabbrev <expr> <buffer> <silent> time: '['.strftime(g:dotoo#time#datetime_format).']'

iabbrev <buffer> todo: TODO
iabbrev <buffer> next: NEXT
iabbrev <buffer> waiting: WAITING
iabbrev <buffer> hold: HOLD
iabbrev <buffer> someday: SOMEDAY
iabbrev <buffer> meeting: MEETING
iabbrev <buffer> phone: PHONE
iabbrev <buffer> cancelled: CANCELLED
iabbrev <buffer> done: DONE

nmap <buffer> gf gF
