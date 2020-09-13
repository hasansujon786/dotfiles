augroup colorextend
  autocmd!
  autocmd ColorScheme * call onedark#extend_highlight("FoldColumn", { "fg": { "gui": "#4b5263" } })
augroup END

let g:onedark_terminal_italics = 1       " support italic fonts

try
  colorscheme onedark
catch
endtry

" put =execute('echo onedark#GetColors()')

" {
"   'green': {'gui': '#98C379', 'cterm': '114', 'cterm16': '2'},
"   'visual_black': {'gui': 'NONE', 'cterm': 'NONE', 'cterm16': '0'},
"   'yellow': {'gui': '#E5C07B', 'cterm': '180', 'cterm16': '3'},
"   'comment_grey': {'gui': '#5C6370', 'cterm': '59', 'cterm16': '15'},
"   'red': {'gui': '#E06C75', 'cterm': '204', 'cterm16': '1'},
"   'special_grey': {'gui': '#3B4048', 'cterm': '238', 'cterm16': '15'},
"   'gutter_fg_grey': {'gui': '#4B5263', 'cterm': '238', 'cterm16': '15'},
"   'visual_grey': {'gui': '#3E4452', 'cterm': '237', 'cterm16': '15'},
"   'cursor_grey': {'gui': '#2C323C', 'cterm': '236', 'cterm16': '8'},
"   'dark_yellow': {'gui': '#D19A66', 'cterm': '173', 'cterm16': '11'},
"   'blue': {'gui': '#61AFEF', 'cterm': '39', 'cterm16': '4'},
"   'purple': {'gui': '#C678DD', 'cterm': '170', 'cterm16': '5'},
"   'black': {'gui': '#282C34', 'cterm': '235', 'cterm16': '0'},
"   'menu_grey': {'gui': '#3E4452', 'cterm': '237', 'cterm16': '8'},
"   'dark_red': {'gui': '#BE5046', 'cterm': '196', 'cterm16': '9'},
"   'white': {'gui': '#ABB2BF', 'cterm': '145', 'cterm16': '7'},
"   'cyan': {'gui': '#56B6C2', 'cterm': '38', 'cterm16': '6'},
"   'vertsplit': {'gui': '#181A1F', 'cterm': '59', 'cterm16': '15'}
" }
