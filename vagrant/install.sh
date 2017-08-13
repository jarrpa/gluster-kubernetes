#!/bin/bash

GLUSTER=" -g"
BLOCK=" --no-block"
OBJ=" --no-object"

while [[ "x${1}" != "x" ]]; do
  if [[ "${1}" == "ssh" ]]; then
    GLUSTER=" --ssh-keyfile /vagrant/insecure_private_key --ssh-user vagrant"
    scp -F ssh-config "${VAGRANT_HOME:-${HOME}/.vagrant.d}/insecure_private_key" master:/vagrant/
    MACHINES=$(vagrant status | grep running | grep node | awk '{print $1}')
    for m in ${MACHINES[*]}; do
      echo "[${m}] Installing GlusterFS..."
      while read -r line; do
        echo -e "\r[${m}] ${line}"
        if [[ "${line}" == "FAIL" ]]; then
          exit 1
        fi
      done <<< "$(vagrant ssh "${m}" -c "sudo yum install -y glusterfs glusterfs-server glusterfs-geo-replication; sudo systemctl enable glusterd; sudo systemctl start glusterd" -- -qn 1>/dev/null 2>&1 || echo "FAIL" && echo "OK")" &
    done
    wait
  fi
  if [[ "${1}" == "block" ]]; then
    BLOCK=" --block-host 10"
  fi
  if [[ "${1}" == obj* ]]; then
    OBJ=" --object-account account --object-user user --object-password password"
  fi
  shift
done

./refresh.sh

s=0
refused=1
echo -en "\r[master] Waiting for Kubernetes service ..."
while [[ ${refused} -eq 1 ]] && [[ ${s} -lt 30 ]]; do
  out=$(ssh -qn -F ssh-config master "kubectl get namespaces" 2>&1)
  echo "${out}" | grep -qv "was refused"
  if [[ ${?} -eq 0 ]]; then
    refused=0
  else
    echo -n "."
    sleep 1
    ((s++))
  fi
done
if [[ ${refused} -eq 0 ]]; then
  echo " OK"
else
  echo " FAIL"
  echo "${out}"
  exit ${refused}
fi

vagrant ssh master -c "cd deploy; sudo ./gk-deploy -vy${GLUSTER}${BLOCK}${OBJ} topology.json.sample"
paplay glass.ogg
