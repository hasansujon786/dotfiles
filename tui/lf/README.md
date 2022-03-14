# doc
https://pkg.go.dev/github.com/gokcehan/lf

https://github.com/BrodieRobertson/dotfiles/blob/master/config/lf/lfrc
https://git.alex.balgavy.eu/dotfiles/file/lf/lfrc.html

$ => execute shell commands
  ex: map i $less %f%

# Command definitions
read           (modal)   (default ':')
shell          (modal)   (default '$')
shell-pipe     (modal)   (default '%')
shell-wait     (modal)   (default '!')
shell-async    (modal)   (default '&')
the prefix shows what kind of command it is
!: runs as interactive shell command (puts lf in the bg)
$: runs as shell command
%: runs as piped shell command (stdout => statusline)
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
lf -remote 'send reload'

cmd open &pwsh -Command Invoke-Item `"$Env:f`" 

https://github.com/sitiom/dotfiles/blob/main/powershell/Microsoft.PowerShell_environment.ps1#L3
map e $&$Env:EDITOR $Env:f
map i $Invoke-Expression "$Env:PAGER $Env:f"
map w $&$Env:SHELL

  vimv --e=nvim $env:fx.replace('"','')


<!-- maybe works -->
lf -remote "send $id :load; select $file"

map ba %{{
    lf -remote "send $id :down; down"
}}
map Q &lf -remote 'send quit'; lf -remote 'quit'



set mouse true
# mouse
map <m-1> down  # primary
map <m-2> down  # secondary
map <m-3> down  # middle
map <m-up>    down
map <m-down>  down

