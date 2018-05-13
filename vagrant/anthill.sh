#!/bin/bash

echo -n "[master] Fetching anthill demo files ... "
vagrant ssh master -c "rm -rf anthill gluster-csi-driver; git clone https://github.com/jarrpa/anthill.git --branch jarrpa-orig --single-branch; git clone https://github.com/jarrpa/gluster-csi-driver.git --branch statefulset-hack --single-branch"
echo "OK"

paplay glass.ogg
