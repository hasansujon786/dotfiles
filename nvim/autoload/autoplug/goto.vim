" File: definition.vim
" Author: romgrk
" Date: 13 May 2016
" Description: Jump where the given expression was last set.
" !::exe [So]

" Example mappings:
" nmap <leader>gc     :Goto command<space>
" nmap <leader>gf     :Goto function<space>
" nmap <leader>gs     :Goto set<space>?<Left>
" nmap <leader>gm     :Goto nmap<space>
" nmap <leader>ga     :Goto abbrev<space>

function! autoplug#goto#_goto (str)
    let str = substitute(a:str, '\v[()]', '', 'g')

    let g:out = ''
    silent! let g:out = execute('verbose ' . str)

    let lastset = matchstr(g:out, 'Last set from \zs\f\+')

    if empty(lastset)
        " @todo: Bettter echo
        echo 'Couldn’t find definition for “'.str.'”'
        " echo printf('“%s”', str)
        " call pp#echo( ['WarningMsg', 'Couldn’t find definition for '],
        "             \ ['String', printf('“%s”', str)])
        return
    end

    execute 'edit ' . lastset

    let what = matchstr(a:str, '\w\+')
    let name = matchstr(a:str, '\v\s*[^ ]\s+\zs\w+')

    "   /     [com|fu|se|nm|…]   [mand|nction|t|ap]?  [!]? <space>      TAG
    let pattern = '\s*' . what[0:1] . '(' . what[2:] . ')?\w*!?\s+.*' . name
    silent! call search('\v' . pattern)
    "echom pattern
endfunc
