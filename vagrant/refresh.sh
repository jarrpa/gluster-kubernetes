#!/bin/bash

G_IMAGE=${GLUSTERFS_IMAGE:-gluster/gluster-centos:latest}
H_IMAGE=${HEKETI_IMAGE:-heketi/heketi:dev}

scp -qrF ssh-config ../deploy master:
scp -qrF ssh-config ../hello_world master:
scp -qrF ssh-config /home/jrivera/projects/golang/src/github.com/gluster/gluster-csi-driver/pkg/glusterfs/deploy/kubernetes master:

echo "[master] Updating GlusterFS manifest..."
vagrant ssh master -c "sudo sed -i 's#gluster/gluster-centos:latest#${G_IMAGE}#' deploy/kube-templates/glusterfs-daemonset.yaml" -- -qn 1>/dev/null 2>&1 || echo "FAIL" && echo "OK"
echo "[master] Updating Heketi manifest..."
vagrant ssh master -c "sudo sed -i 's#heketi/heketi:dev#${H_IMAGE}#' deploy/kube-templates/deploy-heketi-deployment.yaml && sudo sed -i 's#heketi/heketi:dev#${H_IMAGE}#' deploy/kube-templates/heketi-deployment.yaml" -- -qn 1>/dev/null 2>&1 || echo "FAIL" && echo "OK"

MACHINES=$(vagrant status | grep running | grep node | awk '{print $1}')
for m in ${MACHINES[*]}; do
  echo "[${m}] Refreshing GlusterFS image..."
  while read -r line; do
    echo -e "\r[${m}] ${line}"
    if [[ "${line}" == "FAIL" ]]; then
      exit 1
    fi
  done <<< "$(vagrant ssh "${m}" -c "sudo docker pull ${G_IMAGE}; sudo docker pull ${H_IMAGE}; sudo docker pull 192.168.121.1:5000/google_containers/nginx-slim:0.24" -- -qn 1>/dev/null 2>&1 || echo "FAIL" && echo "OK")" &
done
wait
