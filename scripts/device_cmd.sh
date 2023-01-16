#!/bin/sh

last_command=${@:$#}
if [[ "$last_command" == "f" ]]; then
  command=${@:1:$#-1}
  arp -a | tail -n +3 | sed 's/50-8f-4c-49-ca-f9/Redmi Note 4x    /'| fzf | awk '{print $1}' | xargs ${command}
else
  command=${@}
  arp -a | tail -n +3 | grep '50-8f-4c-49-ca-f9' | awk '{print $1}' | xargs ${command}
fi
