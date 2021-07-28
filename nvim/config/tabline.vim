set tabline=%!tabline#_layout()
let g:tabline = {
      \ 'tabs_can_fit': 4,
      \ 'tab_lenght': 26,
      \ 'left_trunc_marker': '',
      \ 'right_trunc_marker': '',
      \ 'modified_icon': '●',
      \ 'close_icon': '',
      \ 'tab_close_icon': '',
      \ 'separator_style': '',
      \ 'double_line': '‖',
      \ 'line_left': '▎'
      \}

" barbar.vim #1c1f24

" hi TabLineFill cleared
autocmd ColorScheme * call tabline#apply_colors()

