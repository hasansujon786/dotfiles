function! netrw#NetrwBrowseX(url, count)
  execute "OpenURL " .a:url
endfunction

fun! netrw#BrowseX(fname,remote)
  execute "OpenURL " .a:fname
endfun

" netrw#CheckIfRemote: returns 1 if current file looks like an url, 0 else {{{2
fun! netrw#CheckIfRemote(...)
  if a:0 > 0
   let curfile= a:1
  else
   let curfile= expand("%")
  endif

  " Ignore terminal buffers
  if &buftype ==# 'terminal'
    return 0
  endif
  if curfile =~ '^\a\{3,}://'
   return 1
  else
   return 0
  endif
endfun
