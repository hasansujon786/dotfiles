
function! s:get_vw_formatted_link(path, title) abort
  let head = './'
  let nested_dir_nr = len(split(fnamemodify(expand('%'), ':~:.'), '/'))
  if (nested_dir_nr > 1)
    let _arr_ = []
    for i in range(nested_dir_nr-1)
      call add(_arr_, '../')
    endfor
    let head = join(_arr_, '')
  endif
  return '['.a:title.']('.head.a:path.')'
endfunction

function! hasan#vimwiki#_create_link_tag()
  let title = hasan#utils#_get_visual_selection()
  let name = s:get_vw_formatted_link('tags/'.title.'.md', title)
  let name = escape(name, '/')

  " \\%V.*\\%V. should select the whole visual selection
  execute "normal! :'<,'>s/\\%V.*\\%V./" . name ."\<cr>"
  execute "w"
endfunction


