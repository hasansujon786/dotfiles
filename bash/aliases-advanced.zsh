# unix
alias -g md='mkdir -p'
alias -g wh='which'
alias -g wt='while true; do'
alias -g s1='sleep 1'
alias -g s2='sleep 2'
alias -g s01='sleep 0.1'
alias -g s05='sleep 0.5'
alias -g A1="| awk '{print \$1}'"
alias -g L='| less'
alias -g H='| head'
alias -g H2='| head -n 20'
alias -g G='| grep'
alias -g Gi='| grep -i'
alias -g GH='| grep HTTP'
alias -g X='| xargs -I1'
alias -g C='| clipcopy'
alias -g Fj='| jq .'
alias -g Fy='| yq .'
alias -g Fx='| xmllint --format -'
alias -g V='| vim -'
#ialias -g grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

# desktop
#alias xauto='xrandr --auto'

# executables
alias cs='create-script'
alias ij='start-intellij'
balias se='session-'
alias acd='asciidoctor'
alias ti='timer'
alias tmzs='timezones'
alias dea='direnv allow'
alias dee='direnv edit'
ialias curl='curl --silent --show-error'
balias clh='curl localhost:'
balias clh8='curl localhost:8080'
balias clh9='curl localhost:9080'
balias c100='curl 192.168.99.100:'
ialias cal='cal -y --monday'

# network
alias wi='sudo wifi-menu'
alias p1='ping 1.1.1.1'
alias p192='ping 192.168.1.1'
alias p8='ping 8.8.8.8'
alias p9='ping 9.9.9.9'

