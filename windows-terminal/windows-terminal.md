https://www.physics.udel.edu/~watson/scen103/ascii.html
https://www.novell.com/documentation/extend52/Docs/help/Composer/books/TelnetAppendixB.html
https://docs.microsoft.com/en-us/windows/terminal/customize-settings/actions
alacritty config https://gist.github.com/hasansujon786/f30fa9d7c57740e5c6e4db35870f7f33

wt -w 0 -F ft -t 3
vim.cmd[[!sed -i '18s/14/18/' 'c:\\Users\\hasan\\AppData\\Local\Microsoft\\Windows Terminal\\settings.json']]
vim.cmd[[!sed -i '18s/18/14/' 'c:\\Users\\hasan\\AppData\\Local\Microsoft\\Windows Terminal\\settings.json']]


      "intenseTextStyle": "bold"

map  ctrl+enter      send_text normal,application \x1b[13;5u
map  shift+enter     send_text normal,application \x1b[13;2u
map  ctrl+tab        send_text normal,application \x1b[9;5u
map  ctrl+shift+tab  send_text normal,application \x1b[9;6u

