#!/bin/bash

echo -n "[master] Fetching anthill demo files ... "
#vagrant ssh master -c "rm -rf anthill gluster-csi-driver; git clone https://github.com/jarrpa/anthill.git --branch jarrpa-orig --single-branch; git clone https://github.com/jarrpa/gluster-csi-driver.git --branch statefulset-hack --single-branch"
vagrant ssh master -c "rm -rf anthill gluster-csi-driver" -- -q && \
rsync -aqe "ssh -qF ssh-config" --exclude='*vendor*' --exclude='*.git*' --no-perms /home/jrivera/projects/golang/src/github.com/gluster/anthill /home/jrivera/projects/golang/src/github.com/gluster/gluster-csi-driver master: && \
echo "OK"

paplay glass.ogg
