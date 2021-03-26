let g:dashboard_fzf_window = 0
let g:dashboard_default_executive ='fzf'

let g:dashboard_custom_header = [
  \' ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓',
  \' ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒',
  \'▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░',
  \'▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ',
  \'▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒',
  \'░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░',
  \'░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░',
  \'   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ',
  \'         ░    ░  ░    ░ ░        ░   ░         ░   ',
  \'                                ░                  ',
  \"         - Hasan's NeoVim Configuration -          ",
  \]

let s:dashboard_shortcut = {}
let s:dashboard_shortcut['find_history'] = 'SPC f h'
let s:dashboard_shortcut['last_session'] = 'SPC b L'
let s:dashboard_shortcut['book_marks']   = 'SPC f b'
let s:dashboard_shortcut['colors']       = 'SPC t c'
let s:dashboard_shortcut['find_file']    = 'SPC f f'
let s:dashboard_shortcut['find_word']    = 'SPC f a'
let s:dashboard_shortcut['new_file']     = 'SPC c n'

let s:dashboard_shortcut_icon = {}
let s:dashboard_shortcut_icon['find_history'] = '  '
let s:dashboard_shortcut_icon['last_session'] = '  '
let s:dashboard_shortcut_icon['book_marks']   = '  '
let s:dashboard_shortcut_icon['colors']       = '  '
let s:dashboard_shortcut_icon['find_file']    = '  '
let s:dashboard_shortcut_icon['new_file']     = '  '
let s:dashboard_shortcut_icon['find_word']    = '  '

let g:dashboard_custom_section = {
    \ 'a_find_history'         :{
          \ 'description': [s:dashboard_shortcut_icon['find_history'].'Recently opened files                 '.s:dashboard_shortcut['find_history']],
          \ 'command':'History'},
    \ 'b_last_session'         :{
          \ 'description': [s:dashboard_shortcut_icon['last_session'].'Open last session                     '.s:dashboard_shortcut['last_session']],
          \ 'command':function('dashboard#handler#last_session')},
    \ 'book_marks'           :{
          \ 'description': [s:dashboard_shortcut_icon['book_marks'].'Jump to bookmarks                     '.s:dashboard_shortcut['book_marks']],
          \ 'command': 'Bookmarks'},
    \ 'colors'   :{
          \ 'description': [s:dashboard_shortcut_icon['colors'].'Change colorscheme                    '.s:dashboard_shortcut['colors']],
          \ 'command':function('dashboard#handler#change_colorscheme')},
    \ 'find_file'            :{
          \ 'description': [s:dashboard_shortcut_icon['find_file'].'Find file                             '.s:dashboard_shortcut['find_file']],
          \ 'command':function('dashboard#handler#find_file')},
    \ 'find_word'            :{
          \ 'description': [s:dashboard_shortcut_icon['find_word'].'Find word                             '.s:dashboard_shortcut['find_word']],
          \ 'command': function('dashboard#handler#find_word')},
    \ 'new_file'             :{
          \ 'description': [s:dashboard_shortcut_icon['new_file'].'New file                              '.s:dashboard_shortcut['new_file']],
          \ 'command':function('dashboard#handler#new_file')},
    \ }

