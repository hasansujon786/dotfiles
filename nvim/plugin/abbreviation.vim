" iabbrev <expr> <buffer> <silent> deadline: 'DEADLINE: ['.strftime(g:dotoo#time#date_day_format).']'
" iabbrev <expr> lorem system('curl -s http://metaphorpsum.com/paragraphs/1')
iab xdate <C-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab <expr> dts strftime("%c")
iab <expr> modt strftime("%c", getftime(expand('%')))
iab reutrn return
iab lenght length
iab re return
iab widht width
iab Sting String
iab sp; &nbsp;
