https://github.com/BrodieRobertson/dotfiles/blob/master/config/lf/lfrc

https://git.alex.balgavy.eu/dotfiles/file/lf/lfrc.html

$ => execute shell commands
  ex: map i $less %f%

# Command definitions
the prefix shows what kind of command it is
$: runs as shell command
%: runs as piped shell command (stdout => statusline)
!: runs as interactive shell command (puts lf in the bg)
:: runs as lf command

map ZZ !{{ echo %SHELL% }}

# open the lfrc, and reload it after saving
cmd edit_config :{{
  $nvim C:\\Users\\hasan\\dotfiles\\tui\\lf\\lfrc
  echo "foo"
}}

# map ZZ !{{ bash --login -i -c 'ls' }}
map ZZ !{{ bash -c 'cd $(fzf)' }}

$current_directory = (pwd).path
$current_directory = pwd
