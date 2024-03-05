command! -nargs=* -complete=expression Goto    call goto#_goto(<q-args>)
command! -nargs=1 -complete=command    GotoCom call goto#_goto('com '.<q-args>)
command! -nargs=1 -complete=function   GotoFu  call goto#_goto('fu '.<q-args>)
command! -nargs=1 -complete=option     GotoSet call goto#_goto('set '.<q-args>.'?')
command! -nargs=1 -complete=mapping    GotoNm  call goto#_goto('nmap '.<q-args>)
command! -nargs=1 -complete=mapping    GotoMap call goto#_goto('map '.<q-args>)
command! -nargs=1 -complete=highlight  GotoHi  call goto#_goto('hi '.<q-args>)

