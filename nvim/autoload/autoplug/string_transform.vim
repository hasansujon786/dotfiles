" File: string-transform.vim
" Author: romgrk
" Date: 26 Mar 2016
" Description:
" !::exe [So]

" function! s:mapfunc (method)
"     exec 'nmap <silent><Plug>(' . a:method . '_operator)  :set opfunc=autoplug#string_transform#_opfunc<CR>"="' . a:method . '"<CR>g@'
"     exec 'vmap <silent><Plug>(' . a:method . '_operator)  :<C-U>call autoplug#string_transform#_opfunc(visualmode(), "' . a:method . '")<CR>'
" endfunc

" call <SID>mapfunc('snake-case')
" call <SID>mapfunc('kebab_case')
" call <SID>mapfunc('start-case')
" call <SID>mapfunc('camel_case')
" call <SID>mapfunc('upper_camel_case')

function! autoplug#string_transform#_opfunc (type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    " If invoked from Visual mode, use '< and '> marks.

        if (!empty(a:000))     | silent exe "normal! `<" . a:type . "`>y"
    elseif (a:type == 'line')  | silent exe "normal! '[V']y"
    elseif (a:type == 'block') | silent exe "normal! `[\<C-V>`]y"
    else                       | silent exe "normal! `[v`]y"
    end

    let method = !empty(a:000) ? a:000[0] : getreg('=')

    let @@ = g:string_transform[method](@@)

    normal! gv""p

    let &selection = sel_save
    let @@         = reg_save
endfunc


let string_transform = {}
function! string_transform.snake_case(string)
    return join(s:split_words(a:string), '_')
endfu
function! string_transform.camel_case(string)
    let words = s:split_words(a:string)
    let string = words[0]
    for word in words[1:]
        let string .= substitute(word, '\v^.', '\u\0', '')
    endfor
    return string
endfu
function! string_transform.upper_camel_case(string)
    return join(map(s:split_words(a:string), {key, word -> substitute(word, '\v^.', '\u\0', '')}), '')
endfu
function! string_transform.kebab_case(string)
    return join(s:split_words(a:string), '-')
endfu
function! string_transform.start_case(string)
    return join(map(s:split_words(a:string), {key, word -> substitute(word, '\v^\l', '\u\0', '')}), ' ')
endfu


function! s:split_words(string)
    let words = split(a:string, '\v_|-|(\u+\zs\ze\u\U)|(\U\zs\ze\u)')
    let i = 0
    for word in words
        if word =~ '\v\u\U+'
            let words[i] = substitute(word, '\v\u\U+', '\l\0', '')
        end
        let i += 1
    endfor
    return words
endfu

" let g:words = <SID>split_words('snake_case')
" let g:words = <SID>split_words('camelCase')
" let g:words = <SID>split_words('camelURLCase')
" let g:words = <SID>split_words('kebab-case')
