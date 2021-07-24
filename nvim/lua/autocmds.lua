local utils = require('hasan.utils')

local autocmds = {
  vimrcEx = {
    {'InsertEnter * norm zz'}, -- center document
    {'VimResized * :wincmd ='}, -- Vim/tmux layout rebalancing
    {'FocusGained * checktime'}, -- Set to auto read when a file is changed from the outside
    {'BufWritePre *.vim,*.lua call hasan#autocmd#trimWhitespace()'},
    {'BufReadPost *  call hasan#autocmd#restore_position()'},
    {'TermOpen * setfiletype terminal | set bufhidden=hide'},
    {'ColorScheme * call hasan#highlight#load_custom_highlight()'},

    {'WinEnter,BufWinEnter,FocusGained * setlocal cursorline'},
    {'WinLeave,FocusLost * setlocal nocursorline'},
    {'WinEnter,BufWinEnter * call hasan#boot#auto_set_cursor_color()'},
    -- {'WinEnter,BufWinEnter *.vim,*.js,*.lua call hasan#boot#highligt_ruler(1)'},
  },
  FernEvents = {
    {'FileType fern call hasan#fern#FernInit()'},
    {'FileType fern call glyph_palette#apply()'},
    {'BufEnter * ++nested call hasan#boot#hijack_directory()'},
    {'VimEnter * ++once runtime! autoload/netrw.vim'},
  },
  FileMarks = {
    {'BufLeave *.html normal! mH'},
    {'BufLeave *.js   normal! mJ'},
    {'BufLeave *.ts   normal! mT'},
    {'BufLeave *.vim  normal! mV'},
    {'BufLeave *.css  normal! mC'},
    {'BufLeave *.txt  normal! mK'},
  }
  -- {"BufEnter term://* setlocal nonumber norelativenumber"};
}
utils.create_augroups(autocmds)

