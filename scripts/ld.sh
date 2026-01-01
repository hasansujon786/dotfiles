#!/bin/bash
last_arg=${*:$#}
main_cmd=${1}
scan_count=9

known_ips='s/50-8f-4c-49-ca-f9/Redmi Note 4x    /;s/aa-d1-20-f7-6e-33/CMF Phone 2 Pro  /'

# 1. Connect device with USB.
# 2. Run "arr"
# 3. Run "acc"

# if [[ "$last_arg" == "-f" || "$last_arg" == "-s" || "$last_arg" == "-sf" ]]; then
#   main_cmd=${@:1:$#-1}
# fi

if [[ "$last_arg" == "-s" ]]; then
	for ((j = 0; j <= scan_count; j++)); do
		ping 192.168.0.10${j} -n 1 -w 100
	done
	echo "___________________________________________________________"
fi

arp -a | tail -n +3 | sed "$known_ips" | fzf | awk '{print $1}' | xargs $main_cmd
