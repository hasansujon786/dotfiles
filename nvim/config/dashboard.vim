let g:dashboard_fzf_window = 0
let g:dashboard_default_executive ='fzf'
" let g:dashboard_custom_footer = []

let g:dashboard_custom_header = [
  \' ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓',
  \' ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒',
  \'▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░',
  \'▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ',
  \'▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒',
  \'░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░',
  \'   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ',
  \'         ░    ░  ░    ░         ░   ░         ░    ',
  \]

let s:icon = {}
let s:icon['fh'] = '  '
let s:icon['tm'] = '  '
let s:icon['ls'] = '  '
let s:icon['bm'] = '  '
let s:icon['cl'] = '  '
let s:icon['ff'] = '  '
let s:icon['nf'] = '  '
let s:icon['fw'] = '  '

let g:dashboard_custom_section = {
      \ 'a_find_history':{
      \   'description': [s:icon['fh'].'Recently opened files                 SPC p r'],
      \   'command':'ProjectRecentFiles'},
      \ 'b_open_terminal':{
      \   'description': [s:icon['tm'].'Open terminal in CWD                  SPC o T'],
      \   'command': 'FloatermNew --wintype=normal --height=10'},
      \ 'c_last_session':{
      \   'description': [s:icon['ls'].'Open last session                     SPC S l'],
      \   'command': function('dashboard#handler#last_session')},
      \ 'd_find_file':{
      \   'description': [s:icon['ff'].'Find project file                     SPC f f'],
      \   'command':function('dashboard#handler#find_file')},
      \ 'e_book_marks':{
      \   'description': [s:icon['bm'].'Jump to bookmarks                     SPC / m'],
      \   'command': 'Bookmarks'},
      \ 'f_find_word':{
      \   'description': [s:icon['fw'].'Search in project                     SPC / p'],
      \   'command': 'RG!'},
      \}
