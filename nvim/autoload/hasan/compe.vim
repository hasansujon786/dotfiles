function! hasan#compe#check_front_char() abort
  return search('\%#[]>)}''"`,]', 'n') ? v:true : v:false
endfunction
