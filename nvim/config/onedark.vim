" let g:onedark_terminal_italics = 1       " support italic fonts
let g:nvcode_termcolors=256
try
  colorscheme onedark
catch
endtry

call hasan#highlight#load_custom_highlight()
