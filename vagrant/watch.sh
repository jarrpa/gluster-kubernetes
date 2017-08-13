#!/bin/bash

vagrant ssh master -c "watch -n1 'kubectl get nodes -o wide; kubectl get deployment,ds,po,svc,ep,secrets,jobs,sa,events --all-namespaces --show-all'"
