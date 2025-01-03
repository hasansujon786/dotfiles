#!/bin/bash

# Better copy
function cpy {
  while read -r data; do               # reads data piped in to cpy
    echo "$data" | cat >/dev/clipboard # echos the data and writes that to /dev/clipboard
  done
  tr -d '\n' </dev/clipboard >/dev/clipboard # removes new lines from the clipboard
}

# system
# alias tmz='sudo timedatectl set-timezone'

# mvn
# alias mvv='mvn -v'
# alias mci='mvn clean install'
# alias mciT='mvn clean install -DskipTests'
# alias mcd='mvn clean deploy'
# alias mcdT='mvn clean deploy -DskipTests'
# alias mp='mvn package'
# alias mpT='mvn package -DskipTests'
# alias mcp='mvn clean package'
# alias mcpT='mvn clean package -DskipTests'
# alias mit='mvn test-compile failsafe:integration-test failsafe:verify'
# alias mc='mvn clean'
# alias mct='mvn clean test'
# alias mgs='mvn generate-sources'
# alias mrr='mvn release:prepare release:perform -DperformRelease=true -DignoreSnapshots=false'
# alias mgat='mvn io.gatling:gatling-maven-plugin:execute'

# svn
# alias svu='svn update'
# alias svs='svn status'
# alias svi='svn info'

# docker
# alias dk='docker'
# alias dkp='docker ps'
# alias dkpa='docker ps -a'
# alias dkpaq='docker ps -a -q'
# alias dkb='docker build -t'
# alias dkbnc='docker build --no-cache -t'
# alias dkr='docker run --rm'
# alias dkrti='docker run --rm -ti'
# alias dkrd='docker run -d'
# alias dkrp8='docker run --rm -p 8080:8080'
# alias dkrp9='docker run --rm -p 9080:9080'
# alias dks='docker start'
# alias dkt='docker stop'
# alias dktt='docker stop $(docker ps -q)'
# alias dkk='docker kill'
# alias dkrm='docker rm'
# alias dkri='docker rmi'
# alias dke='docker exec -ti'
# alias dkl='docker logs -f'
# alias dki='docker images'
# alias dkpu='docker pull'
# alias dkph='docker push'
# alias dkin='docker inspect'
# alias dkn='docker network'
# alias dkc='docker-compose'
# alias dkcu='docker-compose up'
# alias dkclean='docker ps -q -a -f status=exited | xargs -r docker rm && docker images -q -f dangling=true | xargs -r docker rmi'

# kubernetes
# alias kc='kubectl'
# alias kcg='kubectl get'
# alias kcgn='kubectl get --namespace'
# alias kcd='kubectl describe'
# alias kcdn='kubectl describe --namespace'
# alias kcdl='kubectl delete'
# alias kcdln='kubectl delete --namespace'
# alias kcdlp='kubectl-delete-pod'
# alias kcgno='kubectl get nodes'
# alias kcgp='kubectl get pods'
# alias kcgpn='kubectl get pods --namespace'
# alias kcgpp='kubectl get pods --all-namespaces'
# alias kcgd='kubectl get deployments'
# alias kcgdn='kubectl get deployments --namespace'
# alias kcgdd='kubectl get deployments --all-namespaces'
# alias kcgs='kubectl get services'
# alias kcgsn='kubectl get services --namespace'
# alias kcgss='kubectl get services --all-namespaces'
# alias kcgi='kubectl get ingresses'
# alias kcgin='kubectl get ingresses --namespace'
# alias kcgii='kubectl get ingresses --all-namespaces'
# alias kcgc='kubectl get configmaps'
# alias kcgcn='kubectl get configmaps --namespace'
# alias kcgcc='kubectl get configmaps --all-namespaces'
# alias kcgv='kubectl get virtualservices'
# alias kcgvn='kubectl get virtualservices --namespace'
# alias kcgvv='kubectl get virtualservices --all-namespaces'
# alias kcgdr='kubectl get destinationrules'
# alias kcgdrn='kubectl get destinationrules --namespace'
# alias kcgdrr='kubectl get destinationrules --all-namespaces'
# alias kcgg='kubectl get gateways'
# alias kcggn='kubectl get gateways --namespace'
# alias kcggg='kubectl get gateways --all-namespaces'
# alias kcgse='kubectl get serviceentries'
# alias kcgsen='kubectl get serviceentries --namespace'
# alias kcgsee='kubectl get serviceentries --all-namespaces'
# alias kcgr='kubectl get routerules'
# alias kcgrn='kubectl get routerules --namespace'
# alias kcgrr='kubectl get routerules --all-namespaces'
# alias kcgdp='kubectl get destinationpolicies'
# alias kcgdpn='kubectl get destinationpolicies --namespace'
# alias kcgdpp='kubectl get destinationpolicies --all-namespaces'
# alias kcge='kubectl get events --sort-by=".lastTimestamp" --all-namespaces --watch'
# alias kcc='kubectl create'
# alias kccn='kubectl create --namespace'
# alias kca='kubectl apply -f'
# alias kcan='kubectl apply -f --namespace'
# alias kce='kubectl exec -t -i'
# alias kcen='kubectl exec -t -i --namespace'
# alias kcl='kubectl logs -f'
# alias kcll='kubectl-logs'
# alias kcln='kubectl logs -f --namespace'
# alias kcgx='kubectl config get-contexts'
# alias kcux='kubectl config use-context'
# alias kcxsn='kubectl config set-context $(kubectl config current-context) --namespace'
# alias kcpf='kubectl port-forward'
# alias kcpfg='kubectl-port-forward-grafana'
# alias kcpfj='kubectl-port-forward-jaeger'
# alias kcpfk='kubectl-port-forward-kiali'
# alias kcpfp='kubectl-port-forward-prometheus'
# alias kcpfz='kubectl-port-forward-zipkin'
# alias kcdldr='kubectl-delete-default-resources'
# alias kcii='kubectl-ingress-ip-address'
# alias kcni='kubectl-nginx-ip-address'
# alias kcigip='kubectl-istio-gateway-ip-address'
# alias kcignp='kubectl-istio-gateway-http-nodeport'

# istio
# alias ic='istioctl'
# alias icg='istioctl get'
# alias icc='istioctl create -f'
# alias icr='istioctl replace -f'
# alias icdl='istioctl delete'
# alias icij='istioctl kube-inject -f'

# minikube
# alias mks='minikube start'
# alias mkt='minikube stop'

# ibmcloud
# ib -> ibmcloud
# ik -> ibmcloud kubernetes (cs)
# ikr -> ibmcloud container registry (cr)
# alias ib='ibmcloud'
# alias ibl='ibmcloud login'
# alias ibls='ibmcloud login --sso'
# alias ik='ibmcloud cs'
# alias ikc='ibmcloud cs cluster'
# alias ikgc='ibmcloud cs clusters'
# alias ikac='ibmcloud-add-cluster'
# alias ikdlc='ibmcloud cs cluster-rm'
# alias ikgw='ibmcloud cs workers'
# alias ikgr='ibmcloud cs region'
# alias iksr='ibmcloud cs region-set'
# alias ir='ibmcloud cr'
# alias irl='ibmcloud cr login'
# alias irgi='ibmcloud cr images'
# alias ikin='ibmcloud-install-nginx'
# alias ikii='ibmcloud-install-istio'

# global (to be chained with _ -> sudo, or expanded anywhere)

# executables
#ialias -g l='exa -al'
##ialias tree='tree -a -I ".svn|.git|.hg|.idea"'
#alias tree2='tree -L 2'
#alias tree3='tree -L 3'
## ialias -g cat='bat --plain --wrap character'

# arguments
# alias -g cpjson="-XPOST -H 'Content-Type: application/json' -d '{}'"
# alias -g cptext="-XPOST -H 'Content-Type: text/plain' -d"
# alias -g On="--output name"
# alias -g Oj="--output json"
# alias -g Oy="--output yaml"
# alias -g Ow="--output wide"
# alias -g Ot="--template"

# pacman
# alias -g pcy='pacman -Syu'
# alias -g pcs='pacman -S'
# alias -g pcss='pacman -Ss'
# alias -g pcqs='pacman -Qs'
# alias -g pcr='pacman -R'
# alias -g pcrs='pacman -Rs'
# alias -g pcclean='pacman -Rsn $(pacman -Qqdt)'
# alias -g pry='pacaur -Syu'
# alias -g prs='pacaur -S'
# alias -g prss='pacaur -Ss'

# systemctl
# alias -g scl='systemctl'
# alias -g sclss='systemctl status'
# alias -g scle='systemctl enable'
# alias -g scld='systemctl disable'
# alias -g sclr='systemctl restart'
# alias -g scls='systemctl start'
# alias -g sclt='systemctl stop'
# alias -g scldr='systemctl daemon-reload'
# alias -g jou='sudo journalctl -b -n 200 -f'

# java
# alias -g j='java'
# alias -g jc='javac'
# alias -g jj='java -jar'
# alias -g jp='javap -v -l -p -c -s'

# suffix
# alias -s {pdf,PDF}='background mupdf'
# alias -s {jpg,JPG,png,PNG}='background gpicview'
# alias -s {ods,ODS,odt,ODT,odp,ODP,doc,DOC,docx,DOCX,xls,XLS,xlsx,XLSX,xlsm,XLSM,ppt,PPT,pptx,PPTX,csv,CSV}='background libreoffice'
# alias -s {html,HTML}='background chromium'
# alias -s {mp4,MP4,mov,MOV,mkv,MKV}='background vlc'
# alias -s {zip,ZIP,war,WAR}="unzip -l"
# alias -s {jar,JAR}="java -jar"
# alias -s gz="tar -tf"
# alias -s {tgz,TGZ}="tar -tf"
