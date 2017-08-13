#!/bin/bash

MACHINES=(${@:-$(vagrant status | grep running | awk '{print $1}')})

vagrant sandbox rollback "${MACHINES[@]}" || exit 1

for m in ${MACHINES[*]}; do
  echo "[${m}] Restarting services..."
  while read -r line; do
    echo -e "\r[${m}] ${line}"
  done <<< "$(vagrant ssh "${m}" -c "sudo systemctl restart docker kubelet ntpd" -- -qn 2>&1 && echo "OK")" &
done
wait
paplay glass.ogg
