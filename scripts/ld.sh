#!/bin/bash
last_arg=${*:$#}
main_cmd=${1}
scan_count=9

known_ips=(
	'50-8f-4c-49-ca-f9|Redmi Note 4x'
	'92-A3-45-24-08-57|CMF Phone 2 Pro'
)

known_sed=''
for entry in "${known_ips[@]}"; do
	mac=${entry%%|*}
	name=$(printf '%-17.17s' "${entry#*|}")
	known_sed+="s/${mac}/${name}/I;"
done

# 1. Connect device with USB.
# 2. Run "arr"
# 3. Run "acc"

# if [[ "$last_arg" == "-f" || "$last_arg" == "-s" || "$last_arg" == "-sf" ]]; then
#   main_cmd=${@:1:$#-1}
# fi

if [[ "$last_arg" == "-s" ]]; then
	for ((j = 0; j <= scan_count; j++)); do
		ping 192.168.1.10${j} -n 1 -w 100
	done
	echo "___________________________________________________________"
fi

arp -a | tail -n +3 | sed "$known_sed" | fzf | awk '{print $1}' | xargs $main_cmd
