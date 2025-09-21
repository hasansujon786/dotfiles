" if exists('g:loaded_rel_jump')
"   finish
" endif
" let g:loaded_rel_jump = 1

if !exists('g:rel_jump_min_distance')
  let g:rel_jump_min_distance = 3
endif

if !exists('g:rel_jump_first_char')
  let g:rel_jump_first_char = 0
endif

function! reljump#jump(key)
  let distance = v:count1
  if distance >= g:rel_jump_min_distance
    exec "normal! m'"
  endif
  if distance == 1
    exec "normal! ".distance.'g'.a:key
  else
    exec "normal! ".distance.a:key
  endif
  if g:rel_jump_first_char && distance >= g:rel_jump_min_distance
    exec "normal! ^"
  endif
endfunction

