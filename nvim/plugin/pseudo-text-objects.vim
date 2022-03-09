" https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20
" 24 simple pseudo-text objects
" -----------------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
	execute 'xnoremap <silent> i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
	execute 'onoremap <silent> i' . char . ' :normal vi' . char . '<CR>'
	execute 'xnoremap <silent> a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
	execute 'onoremap <silent> a' . char . ' :normal va' . char . '<CR>'
endfor

" line pseudo-text objects
" ------------------------
" il al
xnoremap <silent> il g_o^
onoremap <silent> il :<C-u>normal vil<CR>
xnoremap <silent> al $o0
onoremap <silent> al :<C-u>normal val<CR>

" number pseudo-text object (integer and float)
" ---------------------------------------------
" in
function! VisualNumber()
	call search('\d\([^0-9\.]\|$\)', 'cW')
	normal v
	call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap <silent> in :<C-u>call VisualNumber()<CR>
onoremap <silent> in :<C-u>normal vin<CR>

" buffer pseudo-text objects
" --------------------------
" ia aa
xnoremap <silent> ia :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
onoremap <silent> ia :<C-u>normal via<CR>
xnoremap <silent> aa GoggV
onoremap <silent> aa :<C-u>normal vaa<CR>

" square brackets pseudo-text objects
" -----------------------------------
" ir ar
xnoremap <silent> ir i[
xnoremap <silent> ar a[
onoremap <silent> ir :normal vi[<CR>
onoremap <silent> ar :normal va[<CR>

" block comment pseudo-text objects
" ---------------------------------
" i? a?
xnoremap <silent> a? [*o]*
onoremap <silent> a? :<C-u>normal va?V<CR>
xnoremap <silent> i? [*jo]*k
onoremap <silent> i? :<C-u>normal vi?V<CR>

" last change pseudo-text objects
" -------------------------------
" ik ak
xnoremap <silent> ik `]o`[
onoremap <silent> ik :<C-u>normal vik<CR>
onoremap <silent> ak :<C-u>normal vikV<CR>
