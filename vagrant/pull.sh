#!/bin/bash

IMAGE="${1}"
MACHINES=$(vagrant status | grep running | grep node | awk '{print $1}')

for m in ${MACHINES[*]}; do
  echo "[${m}] Pulling '${IMAGE}'..."
  while read -r line; do
    echo -e "\r[${m}] ${line}"
    if [[ "${line}" == "FAIL" ]]; then
      exit 1
    fi
  done <<< "$(vagrant ssh "${m}" -c "sudo docker pull ${IMAGE} >/dev/null" -- -qn 1>/dev/null 2>&1 || echo "FAIL" && echo "OK")" &
done
wait
paplay glass.ogg
