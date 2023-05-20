#!/bin/sh
last_arg=${@:$#}
main_cmd=${1}
scan_count=3

# 1. Connect device with USB.
# 2. Run "arr"
# 3. Run "acc"

# if [[ "$last_arg" == "-f" || "$last_arg" == "-s" || "$last_arg" == "-sf" ]]; then
#   main_cmd=${@:1:$#-1}
# fi

if [[ "$last_arg" == "-s" || "$last_arg" == "-sf" ]]; then
  for (( j=0; j<=${scan_count}; j++ ));
  do
    ping 192.168.0.10${j} -n 1 -w 100
  done
  echo ""
  echo "**** Scan done ****"
fi

if [[ "$last_arg" == "-f" || "$last_arg" == "-sf" ]]; then
  arp -a | tail -n +3 | sed 's/50-8f-4c-49-ca-f9/Redmi Note 4x    /'| fzf | awk '{print $1}' | xargs ${main_cmd}
else
  arp -a | tail -n +3 | grep '50-8f-4c-49-ca-f9' | awk '{print $1}' | xargs ${main_cmd}
fi
