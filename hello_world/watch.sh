#!/bin/bash

CLI=""
kubectl=$(type kubectl 2>/dev/null | awk '{print $3}')
oc=$(type oc 2>/dev/null | awk '{print $3}')
if [[ "x${oc}" != "x" ]]; then
  CLI="${oc}"
else
  CLI="${kubectl}"
fi

watch -n1 "${CLI} get svc,po,sc,pvc,pv --show-all"
